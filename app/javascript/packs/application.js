// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
// require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

import "../stylesheets/application";
import "./bootstrap_custom.js";

$(function () {
  $(".menu").click(function () {
    if (document.getElementById("open")) {
      let element = $(".dropdown_list");
      $(".dropdown_list").slideUp("fast");
      element.attr("id", "close");
      $(".close").css("display", "block");
      $(".open").css("display", "none");
      $(".contents").css("display", "block");
      $("footer").css("display", "block");
    } else {
      let element = $(".dropdown_list");
      element.attr("id", "open");
      $(".dropdown_list").slideDown();
      $(".close").css("display", "none");
      $(".open").css("display", "block");
      $(".contents").css("display", "none");
      $("footer").css("display", "none");
    }
  });

  $(".search-h").click(function () {
    if (document.getElementById("search_open")) {
      let element = $(".search_wrapper");
      $(".search_wrapper").slideUp();
      element.attr("id", "search_close");
      $(".search-h").css("border-bottom", "solid 1px #E8E8E8");
    } else {
      let element = $(".search_wrapper");
      element.attr("id", "search_open");
      $(".search_wrapper").slideDown();
      $(".search-h").css("border-bottom", "none");
    }
  });

  $(document).ready(function () {
    if (document.getElementById("login_footer")) {
      $("footer").css("height", 280 + "px");
    } else {
      $("footer").css("height", 100 + "px");
    }
  });

  $(".delete_account").click(function () {
    if (document.getElementById("delete_open")) {
      let element = $(".delete_wrapper");
      $(".delete_wrapper").slideUp();
      element.attr("id", "delete_close");
    } else {
      let element = $(".delete_wrapper");
      element.attr("id", "delete_open");
      $(".delete_wrapper").slideDown();
    }
  });

  $("#select_js2").change(function () {
    // 選択されているvalue属性値を取り出す
    var val = $("#select_js2").val();
    if (val == "0") {
      $(".date_area_none").slideUp();
    } else {
      $(".date_area_none").slideDown();
    }
  });
  $("#select_js2").change(function () {
    // 選択されているvalue属性値を取り出す
    var val = $("#select_js2").val();
    if (val == "0") {
      $(".date_area_block").slideUp();
    } else {
      $(".date_area_block").slideDown();
    }
  });

  $("#select_js3").change(function () {
    // 選択されているvalue属性値を取り出す
    var val = $("#select_js3").val();
    if (val == "0") {
      $(".money_area_none").slideUp();
    } else {
      $(".money_area_none").slideDown();
    }
  });

  $("#select_js3").change(function () {
    // 選択されているvalue属性値を取り出す
    var val = $("#select_js3").val();
    if (val == "0") {
      $(".money_area_block").slideUp();
    } else {
      $(".money_area_block").slideDown();
    }
  });

  $("#select_js4").change(function () {
    // 選択されているvalue属性値を取り出す
    var val = $("#select_js4").val();
    if (val != "0") {
      $("#select_js1").val("0");
    }
  });

  $('a[data-toggle="tab"]').on("shown.bs.tab", function (e) {
    var activated_tab = e.target; // activated tab
    if(activated_tab.id==='account'){
      $("#account_or_card").val("0");
    }else{
      $("#account_or_card").val("1");
    }
  });
});