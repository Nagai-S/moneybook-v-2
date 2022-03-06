const copyFunc = (code) => {
  if (code) {
    let clipboard = $("<textarea></textarea>");
    clipboard.text(code);
    $("body").append(clipboard);
    clipboard.select();
    document.execCommand("copy");
    clipboard.remove();
    alert("クリップボードにコピーしました");
  } else {
    alert("データがまだありません");
  }
};

$(function () {
  $(".code_copy").on("click", () => {
    let code = $(".sc_code").text();
    copyFunc(code);
  });
});
