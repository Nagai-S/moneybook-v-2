$(function () {
  $(".ax-source-value").on("keyup", function () {
    let val = $(".ax-source-value").val(); // textareaの入力値を取得
    console.log(val);
    $(".ax-to-value").val(val);
  });
});
