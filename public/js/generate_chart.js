var color = Chart.helpers.color;

//params
var time_format
var x_time
var x
var x_type
var x_label

var colour_vo2max
var vo2_max_starts
var vo2_max_ends
var vo2_max_value
var show_vo2max

var colour_exer
var exer_phase_starts
var exer_phase_ends
var y_exer_phase
var show_exer

var at_value
var show_AT
var at_colour

var generate_param_1
var colour_1
var label_1
var y1
var show_scale_1

var generate_param_2
var colour_2
var label_2
var y2
var show_scale_2

var generate_param_3
var colour_3
var label_3
var y3
var show_scale_3

function setTimeParams(format, time, data, type, label){
  time_format = format
  x_time = time
  x = data
  x_type = type
  x_label = label
}

function setVO2MaxParams(colour, starts, ends, value, show) {
  colour_vo2max = colour
  vo2_max_starts = starts
  vo2_max_ends = ends
  vo2_max_value = value
  show_vo2max = show
}

function setExerParams(colour, starts, ends, value, show){
  colour_exer = colour
  exer_phase_starts = starts
  exer_phase_ends = ends
  y_exer_phase = value
  show_exer = show
}

function setATParams(colour, value, show) {
  at_colour = colour
  at_value = value
  show_AT = show
}

function setParams1(generate, colour, label, data, show){
  generate_param_1 = generate
  colour_1 = colour
  label_1 = label
  y1 = data
  show_scale_1 = show
}

function setParams2(generate, colour, label, data, show){
  generate_param_2 = generate
  colour_2 = colour
  label_2 = label
  y2 = data
  show_scale_2 = show
}

function setParams3(generate, colour, label, data, show){
  generate_param_3 = generate
  colour_3 = colour
  label_3 = label
  y3 = data
  show_scale_3 = show
}



// get time format
function getTimeString(time) {
  return moment(time, time_format);
}

//generate obj to use in the scatter chart
function getDataSet(xArray, yArray) {
  var array_size = yArray.length - 1;

  if(x_time){
    for(var i=0;i < array_size; i++) {
      xArray[i] = getTimeString(xArray[i]);
    }
  }

  var data = new Array();
  for(var i=0;i < array_size; i++) {
    var obj = {
                x: xArray[i],
                y: yArray[i]
              };
    data.push(obj);
  }
  return data;
}


// hex string to rgb
function hexToRgb(hex) {
  var result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
  return result ? {
      r: parseInt(result[1], 16),
      g: parseInt(result[2], 16),
      b: parseInt(result[3], 16)
  } : null;
}

// set time option in case x is a time scale
function getTimeOptions(time_type){
  var time_options = { unit: 'minute', displayFormats: { 'second': 'mm:ss', 'minute': 'mm:ss'},tooltipFormat: "mm:ss" };

  if(time_type == 'time'){
    return time_options;
  }
}

// draw a line to show the VO2max line if required
function drawVO2max(){
 var vo2_max = {
                    borderColor: colour_vo2max,
                    backgroundColor: colour_vo2max,
                    fill: false,
                    label: 'VO2 Max',
                    data:[{
                            x: getTimeString(vo2_max_starts),
                            y: vo2_max_value
                          },
                          {
                            x: getTimeString(vo2_max_ends),
                            y: vo2_max_value
                          }
                          ]
                  };
  return vo2_max;

}

// draw a line to show the VO2max line if required
function drawExerPhase(){
  var exer_phase = {
                    backgroundColor: color(hexToRgb(colour_exer)).alpha(0.4).rgbString(),
                    label: 'Exercise Phase',
                    pointRadius: 0,
                    data:[{
                            x: getTimeString(exer_phase_starts),
                            y: y_exer_phase
                          },
                          {
                            x: getTimeString(exer_phase_ends),
                            y: y_exer_phase
                          }
                          ]
                  };
  return exer_phase;
}


// draw the line for the AT if required
function drawAtLine(){
  var at_line = {
                borderColor: at_colour,
                backgroundColor: at_colour,
                pointRadius: 0,
                label: "AT",
                data:[{
                        x: getTimeString(at_value),
                        y: 0
                      },
                      {
                        x: getTimeString(at_value),
                        y: y_exer_phase
                      }],
                borderDash: [10,5],
                scales: {
                      yAxes: [{
                          display: false,
                          ticks: {
                              suggestedMin: 20,    // minimum will be 0, unless there is a lower value.
                              // OR //
                              // beginAtZero: true   // minimum value will be 0.
                          }
                      }]
                  }
                };
  return at_line;
}

// generate the data array to pass to Chart
function dataSet(vo2, exer, at){
  var dataset = new Array();
  if(vo2){
    dataset.push(drawVO2max());
  }

  if(generate_param_1){
    param1 = {
                xAxisID: "x-axis-0",
                yAxisID: "y-axis-1",
                backgroundColor: color(hexToRgb(colour_1)).alpha(0.5).rgbString(),
                borderColor: colour_1,
                fill: false,
                label: label_1,
                data: getDataSet(x, y1)
              };
    dataset.push(param1);
  }

  if(generate_param_2){
    param2 = {
                xAxisID: "x-axis-0",
                yAxisID: "y-axis-2",
                backgroundColor: color(hexToRgb(colour_2)).alpha(0.5).rgbString(),
                borderColor: colour_2,
                fill: false,
                label: label_2,
                data: getDataSet(x, y2)
              };
    dataset.push(param2)
  }

  if(generate_param_3){
    param3 = {
                xAxisID: "x-axis-0",
                yAxisID: "y-axis-3",
                backgroundColor: color(hexToRgb(colour_3)).alpha(0.5).rgbString(),
                borderColor: colour_3,
                fill: false,
                label: label_3,
                data: getDataSet(x, y3)
              };
    dataset.push(param3)
  }

  if(exer){
    dataset.push(drawExerPhase());
  }

  if(at){
    dataset.push(drawAtLine());
  }

  return dataset;
}

// get y scale options
function  getYaxisOptions(){
  scale = new Array();

  if(generate_param_1){
    y1_scale = {
                type: "linear",
                display: show_scale_1,
                position: "left",
                id: "y-axis-1",
                scaleLabel: {
                              display: true,
                              labelString: label_1,
                            },
                };
    scale.push(y1_scale);
  }


  if(generate_param_2){
    y2_scale = {
                type: "linear",
                display: show_scale_2,
                position: "right",
                id: "y-axis-2",
                scaleLabel: {
                              display: true,
                              labelString: label_2,
                            },
                gridLines: {
                  drawOnChartArea: false,
                  }
                };
    scale.push(y2_scale);
  }

  if(generate_param_3){
    y3_scale = {
                type: "linear",
                display: show_scale_3,
                position: "right",
                id: "y-axis-3",
                scaleLabel: {
                              display: true,
                              labelString: label_3
                            },
                gridLines: {
                  drawOnChartArea: false,
                  }
                };
  scale.push(y3_scale);
  }


  return scale;
}

// generate x scale options
function getXscaleOptions(){
  x_options = {
                type: x_type,
                position: 'bottom',
                scaleLabel: {
                  display: true,
                  labelString: x_label
                },
              };

  if(x_time){
    x_options["time"] = getTimeOptions(x_type);
  }else{
    x_options["ticks"] = {
      beginAtZero: true,
      max: 2500
    }
  }
  console.log(x_options);
  return x_options;
}

function getConfig(){
  var config = {
                type: 'line',
                data: {
                    datasets: dataSet(show_vo2max,show_exer, show_AT),
                },

                options: {
                  responsive: true,

                  scales: {
                      yAxes: getYaxisOptions(),
                      xAxes: [getXscaleOptions()]
                          },

                  legend: {
                    display: true,
                    position: 'top',
                    labels: {
                      filter: function(legendItem, data) {
                        if (legendItem.text != "AT"){
                          var data = data.datasets[legendItem.datasetIndex]
                          return !data.legendHidden;
                        }
                      }
                    }
                  }
                }
              }

  return config;
}