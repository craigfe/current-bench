'use strict';

var C3 = require("c3");
var Curry = require("bs-platform/lib/js/curry.js");
var React = require("react");

var Benchmark = { };

var Value = { };

var leftButtonStyle = {
  width: "48px",
  borderRadius: "4px 0px 0px 4px"
};

var rightButtonStyle = {
  width: "48px",
  borderRadius: "0px 4px 4px 0px"
};

var initialState = {
  count: 0
};

function reducer(state, action) {
  if (action) {
    return {
            count: state.count - 1 | 0
          };
  } else {
    return {
            count: state.count + 1 | 0
          };
  }
}

var chart_data = {
  columns: /* array */[
    /* array */[
      "data1",
      30,
      200,
      100,
      400,
      150,
      250
    ],
    /* array */[
      "data2",
      50,
      20,
      10,
      40,
      15,
      25
    ]
  ]
};

var chart = {
  bindto: "#chart",
  data: chart_data
};

var org = "mirage";

var repo = "index";

function App(Props) {
  var match = React.useReducer(reducer, initialState);
  var dispatch = match[1];
  React.useEffect((function () {
          return (function (param) {
                    console.log(C3.generate(chart));
                    return /* () */0;
                  });
        }), ([]));
  return React.createElement(React.Fragment, undefined, React.createElement("div", {
                  className: "header"
                }, React.createElement("h1", undefined, "Benchmarks for ", React.createElement("a", {
                          href: "https://github.com/mirage/index"
                        }, "mirage/index"), ".")), React.createElement("div", {
                  className: "content"
                }, React.createElement("p", undefined, "Showing results for commit ", React.createElement("a", {
                          href: "https://github.com/mirage/index/tree/0adda73019f9f3a947c224b37ceb54d0f36d5fc4"
                        }, "0adda73019"), "."), React.createElement("div", {
                      className: "container"
                    }, React.createElement("div", {
                          className: "containerTitle"
                        }, React.createElement("code", undefined, "write_sync")), React.createElement("div", {
                          className: "containerContent"
                        }, React.createElement("div", {
                              style: {
                                display: "flex",
                                alignItems: "center",
                                justifyContent: "space-between"
                              }
                            }, React.createElement("div", {
                                  id: "chart"
                                }), React.createElement("div", undefined, React.createElement("button", {
                                      style: leftButtonStyle,
                                      onClick: (function (_event) {
                                          return Curry._1(dispatch, /* Decrement */1);
                                        })
                                    }, "-"), React.createElement("button", {
                                      style: rightButtonStyle,
                                      onClick: (function (_event) {
                                          return Curry._1(dispatch, /* Increment */0);
                                        })
                                    }, "+"), React.createElement("button", {
                                      style: rightButtonStyle,
                                      onClick: (function (_event) {
                                          console.log(C3.generate(chart));
                                          return /* () */0;
                                        })
                                    }, "Click me")))))));
}

console.log(chart);

console.log(C3.generate(chart));

var make = App;

exports.Benchmark = Benchmark;
exports.Value = Value;
exports.leftButtonStyle = leftButtonStyle;
exports.rightButtonStyle = rightButtonStyle;
exports.initialState = initialState;
exports.reducer = reducer;
exports.chart = chart;
exports.org = org;
exports.repo = repo;
exports.make = make;
/*  Not a pure module */
