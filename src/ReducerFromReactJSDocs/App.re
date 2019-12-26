
module Benchmark = {
  type single = {
    name: string,
    y_units: string,
    results: array(int),
  }

  type t = {
    commit: string,
    results: array(single),
  }
}

module Value = {
  type t;
  external int : int => t = "%identity";
  external string : string => t = "%identity";
};

type data = {
  columns: array(array(Value.t))
}

type generateArg = {
  bindto: string,
  data: data
};

[@ms.module "d3"]
[@bs.module "c3"] external generate : generateArg => Js.t(unit) = "generate";

// A little extra we've put, because the ReactJS example has no styling
let leftButtonStyle = ReactDOMRe.Style.make(~borderRadius="4px 0px 0px 4px", ~width="48px", ());
let rightButtonStyle = ReactDOMRe.Style.make(~borderRadius="0px 4px 4px 0px", ~width="48px", ());

// Record and variant need explicit declarations.
type state = {count: int};

type action =
  | Increment
  | Decrement;

let initialState = {count: 0};

let reducer = (state, action) => {
  switch (action) {
  | Increment => {count: state.count + 1}
  | Decrement => {count: state.count - 1}
  };
};

let chart = {
  bindto: "#chart",
  data: { columns: Value.[|
                          [| string("data1"), int(30), int(200), int(100), int(400), int(150), int(250) |],
                          [| string("data2"), int(50), int(20), int(10), int(40), int(15), int(25) |]
                          |] }
};

let org = "mirage";
let repo = "index";

[@react.component]
let make = () => {
  let (state, dispatch) =
    React.useReducer(reducer, initialState);

  React.useEffect0(() => Some(() => Js.log(generate(chart))));

  // We can use a fragment here, but we don't, because we want to style the counter
  <>
  <div className="header">
    <h1>{React.string("Benchmarks for ")}<a href="https://github.com/mirage/index">{React.string(org ++ "/" ++ repo)}</a>{React.string(".")}</h1>
  </div>
  <div className="content">
  <p>
    {React.string("Showing results for commit ")}
    <a href="https://github.com/mirage/index/tree/0adda73019f9f3a947c224b37ceb54d0f36d5fc4">
      {React.string("0adda73019")}
    </a>
    {React.string(".")}
  </p>
  <div className="container">
    <div className="containerTitle">
        <code>
            {React.string("write_sync")}
        </code>
    </div>
    <div className="containerContent">
      <div
        style={ReactDOMRe.Style.make(~display="flex", ~alignItems="center", ~justifyContent="space-between", ())}>
        <div id="chart" />
        <div>
          <button style=leftButtonStyle onClick={_event => dispatch(Decrement)}>
            {React.string("-")}
          </button>
          <button style=rightButtonStyle onClick={_event => dispatch(Increment)}>
            {React.string("+")}
        </button>
        <button style=rightButtonStyle onClick={_event => Js.log (generate(chart)) }>
            {React.string("Click me")}
        </button>
        </div>
      </div>
    </div>
  </div>
  </div>
  </>;
};

Js.log (chart);
Js.log (generate(chart));
