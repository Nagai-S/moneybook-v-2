$(function () {
  $(".fund_user_button").on("click", (e) => {
    e.preventDefault(); // デフォルトのイベント(HTMLデータ送信など)を無効にする
    let average_buy_value = $(".average_buy_value").val(); // textareaの入力値を取得
    let url = $("#fund_user_update").attr("action"); // action属性のurlを抽出
    $.ajax({
      url: url,
      type: "PATCH",
      data: {
        fund_user: { average_buy_value: average_buy_value },
      },
      dataType: "json", // レスポンスデータをjson形式と指定する
    })
      .done((data) => {
        $(".status_message").remove();
        if (data.status === "success") {
          $(".fund_user_update_form").append(
            '<p class="status_message gain_value">更新しました。</p>'
          );
        } else if (data.status === "error") {
          $(".fund_user_update_form").append(
            '<p class="status_message loss_value">正しい値を入力してください。</p>'
          );
        }
      })
      .always(function () {
        $(".fund_user_button").prop("disabled", false);
        $(".fund_user_button").removeAttr("data-disable-with");
      });
  });
});
