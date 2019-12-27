# Benchmarking Infrastructure

**UNDER DEVELOPMENT -- DO NOT USE**

OCaml benchmarking infrastructure using the holy Trinity of
[OCurrent][ocurrent], [Irmin][irmin] and [ReasonReact][reason-react].

Split into three components:

- `/runner` (TODO): various mechanisms for running benchmarks (including an
  [OCurrent][ocurrent] pipeline).
- `/backend` (TODO): logic for an [Irmin][irmin] store to contain benchmarking
  data.
- `/frontend` (TODO): a [ReasonReact][reason-react] frontend for visualising
  data contained in the Irmin store.

Architecture is as follows:

```text
+-----------+ Commits
| Developer +----+                    +----------+
+-----------+    |     +--------+ PRs | OCurrent |
                 +---->+ GitHub +---->+ pipeline |....   +-----------+
                 |     +--------+     +----------+   |   |  Remote   |
+-----------+    |                        |          |   | benchmark |
| Developer +----+             ...........|.............>+  machine  |
+-----------+                  |          |    Docker    +-----------+
                               |          |    swarm
                       +--------------+   |            +-------+
+-----------+          | OCurrent CLI |   |            | Irmin |
| Developer +--------->+    runner    +--------------->+ store |
+-----------+          +--------------+     Results    +-------+
                                                           |
                       +--------------+                    |
+-----------+          | Reason-React |                    |
| Developer +<---------+    & C3js    +<-------------------+
+-----------+          +--------------+     GraphQL API
```

[ocurrent]: https://ocurrent.org/
[irmin]: https://irmin.io/
[reason-react]: https://reasonml.github.io/reason-react/
