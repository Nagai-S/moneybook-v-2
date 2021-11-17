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

const formContents = (element) => {
  return [
    $(".sc_email").val(),
    $(".sc_password").val(),
    element.find(".sc_genre").val(),
    element.find(".sc_account_or_card").val(),
    element.find(".sc_account").val(),
    element.find(".sc_card").val()
  ]
}

$(function () {
  $(".sc_tab_link").on("click", function (e) {
    var activated_tab = e.target; // activated tab
    if (activated_tab.id == "ex_tab_btn") {
      $(".create_shortcut_button").addClass("ex");
      $(".create_shortcut_button").removeClass("in");
    } else if (activated_tab.id == "in_tab_btn") {
      $(".create_shortcut_button").addClass("in");
      $(".create_shortcut_button").removeClass("ex");
    }
  });
  
  $(".create_shortcut_button").on("click", (e) => {
    e.preventDefault();
    let iae = '';
    let [email, password, genre_id, account_or_card, account_id, card_id] = [ "", "", "", "", "", ""];
    if ($(".create_shortcut_button").hasClass('ex')) {
      iae = false;
      [email, password, genre_id, account_or_card, account_id, card_id] =
        formContents($("#create_shortcut_tab_ex"));
    } else if ($(".create_shortcut_button").hasClass('in')) {
      iae = true;
      [email, password, genre_id, account_or_card, account_id, card_id] =
        formContents($("#create_shortcut_tab_in"));
    }
    $.ajax({
      url: "/api/v1/auth/sign_in",
      type: "POST",
      data: {
        email: email,
        password: password,
      },
      dataType: "json",
    })
      .done((data, status, xhr) => {
        $(".status_message").remove();
        $(".code_result").append(
          scResultHtml(xhr, iae, genre_id, account_or_card, account_id, card_id)
        );
      })
      .fail(() => {
        $(".status_message").remove();
        $(".authentication").append(failedGetSC);
      })
      .always(function () {
        $(".create_shortcut_button").prop("disabled", false);
        $(".create_shortcut_button").removeAttr("data-disable-with");
      });
  });

  $(".code_copy").on("click", () => {
    let code = $(".sc_code").text();
    copyFunc(code);
  })

});
