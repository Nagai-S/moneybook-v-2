$(function () {
  $(".genre_update_button").on("click", (e) => {
    e.preventDefault(); // デフォルトのイベント(HTMLデータ送信など)を無効にする
    let name = $(".genre_name").val(); // textareaの入力値を取得
    let url = $("#genre_update_form").attr("action"); // action属性のurlを抽出
    $.ajax({
      url: url,
      type: "PATCH",
      data: {
        genre: { name: name },
      },
      dataType: "json",
    })
      .done((data) => {
        $(".status_message").remove();
        if (data.status === "success") {
          $(".genre_update_form").append(
            '<p class="status_message loss_value">更新しました。</p>'
          );
        } else if (data.status === "error") {
          $(".genre_update_form").append(
            '<p class="status_message gain_value">更新に失敗しました。</p>'
          );
        }
      })
      .always(function () {
        $(".genre_update_button").prop("disabled", false);
        $(".genre_update_button").removeAttr("data-disable-with");
      });
  });
});
