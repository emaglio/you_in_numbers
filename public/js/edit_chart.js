var y1_colour = document.getElementById("y1_colour")
var y1_scale = document.getElementById("y1_scale")
var y2_colour = document.getElementById("y2_colour")
var y2_scale = document.getElementById("y2_scale")
var y3_colour = document.getElementById("y3_colour")
var y3_scale = document.getElementById("y3_scale")
var x_format = document.getElementById("x_format")
var exer_colour = document.getElementById("exer_colour")
var vo2max_colour = document.getElementById("vo2max_colour")
var at_colour = document.getElementById("at_colour")
var vo2max_check = document.getElementById("vo2max_show");
var exer_check = document.getElementById("exer_show");
var at_check = document.getElementById("at_show");

function y1(){
  var y1 = document.getElementById("y1_select");

  if(y1.options[y1.selectedIndex].value == "none"){
    y1_colour.disabled = true;
    y1_colour.style.opacity = '100%';
    y1_scale.disabled = true;
  }else{
    y1_colour.disabled = false;
    y1_scale.disabled = false;
  }
}

function y2(){
  var y2 = document.getElementById("y2_select");

  if(y2.options[y2.selectedIndex].value == "none"){
    y2_colour.disabled = true;
    y2_colour.style.opacity = '100%';
    y2_scale.disabled = true;
  }else{
    y2_colour.disabled = false;
    y2_scale.disabled = false;
  }
}

function y3(){
  var y3 = document.getElementById("y3_select");

  if(y3.options[y3.selectedIndex].value == "none"){
    y3_colour.disabled = true;
    y3_colour.style.opacity = '100%';
    y3_scale.disabled = true;
  }else{
    y3_colour.disabled = false;
    y3_scale.disabled = false;
  }
}

function x_time(){
  var time = document.getElementById("x_time");
  if(time.checked){
    x_format.disabled = false;
    vo2max_check.disabled = false;
    vo2max_colour.disabled = false;
    exer_check.disabled = false;
    exer_colour.disabled = false;
    at_check.disabled = false
    at_colour.disabled = false;
    x_format.focus();
  }else{
    x_format.disabled = true;
    vo2max_check.disabled = true;
    vo2max_colour.disabled = true;
    exer_check.disabled = true;
    exer_colour.disabled = true;
    at_check.disabled = true
    at_colour.disabled = true;
  }
}


function vo2max_show(){
  var vo2max = document.getElementById("vo2max_show");
  if(vo2max.checked){
    vo2max_colour.disabled = false;
  }else{
    vo2max_colour.disabled = true;
  }
}

function exer_show(){
  var exer = document.getElementById("exer_show");
  if(exer.checked){
    exer_colour.disabled = false;
  }else{
    exer_colour.disabled = true;
  }
}

function at_show(){
  var at = document.getElementById("at_show");

  if(at.checked){
    at_colour.disabled = false;
  }else{
    at_colour.disabled = true;
  }
}

window.onload=function() {
  y1()
  y2()
  y3()
  x_time()
  vo2max_show()
  exer_show()
  at_show()
}


document.getElementById("y1_select").onchange=function() {
  y1()
}

document.getElementById("y2_select").onchange=function() {
  y2()
}

document.getElementById("y3_select").onchange=function() {
  y3()
}


document.getElementById("x_time").onchange=function() {
  x_time()
}

document.getElementById("vo2max_show").onchange=function() {
  vo2max_show()
}

document.getElementById("exer_show").onchange=function() {
  exer_show()
}

document.getElementById("at_show").onchange=function() {
  at_show()
}
