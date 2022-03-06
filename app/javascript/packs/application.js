// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start();
// require("turbolinks").start()
require("@rails/activestorage").start();
require("channels");
// import "chartkick/chart.js";
// require("chartkick")
// require("chart.js")
require("chartkick").use(require("highcharts"));

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
    let element = $(".dropdown_list");
    if (document.getElementById("open")) {
      element.slideUp("fast");
      element.attr("id", "close");
      $(".close").css("display", "block");
      $(".open").css("display", "none");
      $(".contents").css("display", "block");
      $("footer").css("display", "block");
    } else {
      element.attr("id", "open");
      element.slideDown();
      $(".close").css("display", "none");
      $(".open").css("display", "block");
      $(".contents").css("display", "none");
      $("footer").css("display", "none");
    }
  });

  $(".search-h").click(function () {
    let element = $(".search_wrapper");
    if (document.getElementById("search_open")) {
      element.slideUp();
      element.attr("id", "search_close");
      $(".search-h").css("border-bottom", "solid 1px #E8E8E8");
    } else {
      element.attr("id", "search_open");
      element.slideDown();
      $(".search-h").css("border-bottom", "none");
    }
  });

  $(document).ready(function () {
    if (document.getElementById("login_footer")) {
      $("footer").css("height", 340 + "px");
    } else {
      $("footer").css("height", 100 + "px");
    }
  });

  $(".delete_account").click(function () {
    let element = $(".delete_wrapper");
    if (document.getElementById("delete_open")) {
      element.slideUp();
      element.attr("id", "delete_close");
    } else {
      element.attr("id", "delete_open");
      element.slideDown();
    }
  });

  $("#date_select").change(function () {
    // 選択されているvalue属性値を取り出す
    var val = $("#date_select").val();
    if (val == "0") {
      $(".date_area_none").slideUp();
    } else {
      $(".date_area_none").slideDown();
    }
  });
  $("#date_select").change(function () {
    // 選択されているvalue属性値を取り出す
    var val = $("#date_select").val();
    if (val == "0") {
      $(".date_area_block").slideUp();
    } else {
      $(".date_area_block").slideDown();
    }
  });

  $("#money_select").change(function () {
    // 選択されているvalue属性値を取り出す
    var val = $("#money_select").val();
    if (val == "0") {
      $(".money_area_none").slideUp();
    } else {
      $(".money_area_none").slideDown();
    }
  });

  $("#money_select").change(function () {
    // 選択されているvalue属性値を取り出す
    var val = $("#money_select").val();
    if (val == "0") {
      $(".money_area_block").slideUp();
    } else {
      $(".money_area_block").slideDown();
    }
  });

  $("#genre_select").change(function () {
    // 選択されているvalue属性値を取り出す
    var val = $("#genre_select").val();
    if (val != "") {
      $("#iae_select").val("0");
    }
  });

  // select tab about account or card
  $(".aoc_link").on("click", function (e) {
    var activated_tab = e.target; // activated tab
    if (activated_tab.id == "account") {
      $("#account_or_card").val("0");
    } else if (activated_tab.id == "card") {
      $("#account_or_card").val("1");
    } else {
      $("#account_or_card").val("2");
    }
  });
});
