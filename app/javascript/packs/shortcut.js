const scResultHtml = (
  xhr,
  iae, 
  genre_id, 
  account_or_card, 
  account_id, 
  card_id
) =>{
  return (
    '<p class="status_message">こちらに表示されている文字列をコピーしてください。</p>' +
    '<div class="status_message sc_message">' +
      '<p class="sc_code">' +
        "{</br>" +
          "\"access-token\":" + "\"" + xhr.getResponseHeader("access-token") + "\"" + ",</br>" +
          "\"client\":" + "\"" + xhr.getResponseHeader("client") + "\"" + ",</br>" +
          "\"uid\":" + "\"" + xhr.getResponseHeader("uid") + "\"" + ",</br>" +
          "\"iae\":" + iae + ",</br>" +
          "\"genre_id\":" + genre_id + ",</br>" +
          "\"account_or_card\":" + "\"" + account_or_card + "\"" + ",</br>" +
          "\"account_id\":" + account_id + ",</br>" +
          "\"card_id\":" + card_id + "</br>" +
        "}</br>" +
      "</p>" +
    "</div>" +
    '<p class="status_message add_sc"><a href="https://www.icloud.com/shortcuts/785de3d80b3b458aab44366d6f62d4b1">' +
    "こちら" +
    "</a>からショートカットを追加してください</p>"
  );
}

const failedGetSC = '<p class="status_message gain_value">メールまたはパスワードが違います。</p>';

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
    alert('データがまだありません')
  }
}

$(function () {
  $(".create_shortcut_button_false").on("click", (e) => {
    e.preventDefault(); // デフォルトのイベント(HTMLデータ送信など)を無効にする
    let iae = false;
    let email = $("#create_shortcut_tab_ex").find(".sc_email").val();
    let password = $("#create_shortcut_tab_ex").find(".sc_password").val();
    let genre_id = $("#create_shortcut_tab_ex").find(".sc_genre").val();
    let account_or_card = $("#create_shortcut_tab_ex").find(".sc_account_or_card").val();
    let account_id = $("#create_shortcut_tab_ex").find(".sc_account").val();
    let card_id = $("#create_shortcut_tab_ex").find(".sc_card").val();
    let url = $("#create_shortcut_tab_ex").attr("action"); // action属性のurlを抽出
    $.ajax({
      url: url,
      type: "POST",
      data: {
        email: email,
        password: password,
      },
      dataType: "json",
    })
      .done((data, status, xhr) => {
        $(".status_message").remove();
        $(".code_result_false").append(
          scResultHtml(xhr, iae, genre_id, account_or_card, account_id, card_id)
        );
      })
      .fail(() => {
        $(".status_message").remove();
        $("#create_shortcut_tab_ex").append(failedGetSC);
      })
      .always(function () {
        $(".create_shortcut_button_false").prop("disabled", false);
        $(".create_shortcut_button_false").removeAttr("data-disable-with");
      });
  });

  $(".create_shortcut_button_true").on("click", (e) => {
    e.preventDefault(); // デフォルトのイベント(HTMLデータ送信など)を無効にする
    let iae = true;
    let email = $("#create_shortcut_tab_in").find(".sc_email").val();
    let password = $("#create_shortcut_tab_in").find(".sc_password").val();
    let genre_id = $("#create_shortcut_tab_in").find(".sc_genre").val();
    let account_or_card = $("#create_shortcut_tab_in").find(".sc_account_or_card").val();
    let account_id = $("#create_shortcut_tab_in").find(".sc_account").val();
    let card_id = $("#create_shortcut_tab_in").find(".sc_card").val();
    let url = $("#create_shortcut_tab_in").attr("action"); // action属性のurlを抽出
    $.ajax({
      url: url,
      type: "POST",
      data: {
        email: email,
        password: password,
      },
      dataType: "json",
    })
      .done((data, status, xhr) => {
        $(".status_message").remove();
        $(".code_result_true").append(
          scResultHtml(xhr, iae, genre_id, account_or_card, account_id, card_id)
        );
      })
      .fail(() => {
        $(".status_message").remove();
        $("#create_shortcut_tab_in").append(failedGetSC);
      })
      .always(function () {
        $(".create_shortcut_button_true").prop("disabled", false);
        $(".create_shortcut_button_true").removeAttr("data-disable-with");
      });
  });

  $(".code_result_false").find(".code_copy").on("click", () => {
    let code = $(".code_result_false").find(".sc_code").text();
    copyFunc(code);
  })

  $(".code_result_true").find(".code_copy").on("click", () => {
    let code = $(".code_result_true").find(".sc_code").text();
    copyFunc(code);
  })
});
