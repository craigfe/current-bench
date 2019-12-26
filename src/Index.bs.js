'use strict';

var React = require("react");
var ReactDOMRe = require("reason-react/src/ReactDOMRe.js");
var App$ReasonReactExamples = require("./ReducerFromReactJSDocs/App.bs.js");
var ExampleStyles$ReasonReactExamples = require("./ExampleStyles.bs.js");

var style = document.createElement("style");

document.head.appendChild(style);

style.innerHTML = ExampleStyles$ReasonReactExamples.style;

ReactDOMRe.renderToElementWithId(React.createElement(App$ReasonReactExamples.make, { }), "root");

exports.style = style;
/* style Not a pure module */
