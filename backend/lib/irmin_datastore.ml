[@@@warning "-32"]

module Uuidm = struct
  include Uuidm

  let t =
    let of_string s =
      match of_string s with
      | Some s -> s
      | None -> Fmt.failwith "Invalid UUID: %s" s
    in
    Irmin.Type.(map string) of_string to_string
end

(* Structure of the store:

    <org>/<repo>/<commit_hash>/<bench_name>/{bench_data list}
 *)

module Data = struct
  include Yojson.Safe

  let t = Irmin.Type.(map string) from_string to_string
end

module Benchmark = struct
  type bench_data = { uuid : Uuidm.t; data : Data.t } [@@deriving irmin]

  type t = bench_data list [@@deriving irmin]

  let merge = Irmin.Merge.(option (default t))
end

let random_bench_data () : (string * Benchmark.t) list =
  [
    ( "write_sync",
      [
        {
          uuid = Uuidm.create `V4;
          data = `Tuple [ `String "microseconds per op"; `Int (Random.int 10) ];
        };
      ] );
    ( "read_sync",
      [
        {
          uuid = Uuidm.create `V4;
          data = `Tuple [ `String "microseconds per op"; `Int (Random.int 200) ];
        };
      ] );
  ]

let commit_hashes =
  [
    "0adda73019f9f3a947c224b37ceb54d0f36d5fc4";
    "66fa77bc7ef21c49f567330fc94f1d0c69a4c9aa";
    "770fab4f7a5ef0f38b9e13551298c4f94463fc1e";
    "52e21ac0f67e55184780e5cdaecc45ba2fc655d0";
    "9f737441b7fe7948d1031155e96bef358dcac633";
    "c628c9ee8c91eaf611700fc20e8ade44c41d9fc1";
    "5f8b5df455f1b895272e3fc0ec0fbbba2ade38ca";
    "86aa2fb1169ec711d8fb3bc35ab2c7ec3bc23e26";
    "749949ec747c9f379bdae820dbee5819d600e073";
    "ed6feaf89d2f50a06786950f3293bd9175c8367b";
    "c42c663acb97c9b30edd575d8e2b9985aab2b4c9";
    "a899d2fa286e129241cda520c20b321fdca05f50";
    "de56e7988855e84c3f2a6a58bc4ecff1983bdf83";
    "71b42fd29354bb4dc333a6973f27f163d90aa596";
    "b746b66ccb0aad90c9c3da3fc659e0a1dd8ca4f3";
    "3466767f37ac273eb2dccd111838674e86db6663";
    "dc576caa5ee0426ccdb43725728e3c3519c46950";
    "7ba3081fd6386a62815200c432d1a682f12b62a3";
  ]

let initial_data =
  [
    ( "mirage",
      [ ("index", List.map (fun h -> (h, random_bench_data ())) commit_hashes) ]
    );
  ]

module Store = Irmin_mem.KV (Benchmark)
module Custom_types = Irmin_graphql.Server.Default_types (Store)

module Config = struct
  let remote = None

  let info = Irmin_unix.info
end

module Graphql =
  Irmin_graphql.Server.Make_ext (Cohttp_lwt_unix.Server) (Config) (Store)
    (Custom_types)

let ( let* ) = Lwt.Infix.( >>= )

(* Initialize the Irmin store *)
let initialise_store s =
  let ( >>- ) xs f =
    Lwt_list.fold_left_s
      (fun t (k, x) ->
        let* v = f x in
        Store.Tree.add_tree t [ k ] v)
      Store.Tree.empty xs
  in
  let* tree =
    initial_data >>- fun repos ->
    repos >>- fun commits ->
    commits >>- fun benches ->
    benches >>- fun data -> Lwt.return (Store.Tree.of_contents data)
  in
  Store.set_tree_exn ~info:(fun () -> Irmin.Info.empty) s [] tree

(* Initialize the GraphQL server *)
let initialise_server repo =
  let* () =
    Logs_lwt.app (fun m ->
        m
          "Running the GraphQL server on port 1234@,\
           See http://localhost:1234/graphql for a GraphiQL interface")
  in
  let on_exn exn =
    Logs.debug (fun l -> l "on_exn: %s" (Printexc.to_string exn))
  in
  repo
  |> Graphql.v
  |> Cohttp_lwt_unix.Server.create ~on_exn ~mode:(`TCP (`Port 1234))

let main () =
  let open Store in
  let* () = Logs_lwt.app (fun m -> m "@,") in
  let* repo = Repo.v (Irmin_git.config "/tmp/irmin") in
  let* t = Store.master repo in
  let* () = initialise_store t in
  initialise_server repo
