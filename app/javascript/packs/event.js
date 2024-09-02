$(function () {
  $(".account-select").on("change", function () {
    let currency_id = $(".account-select option:selected").data("currency");
    console.log(currency_id);
    $(".currency-select").val(currency_id);
  });

  $(".account-select").eq(1).on("change", function () {
    let currency_id = $(".account-select option:selected").eq(1).data("currency");
    console.log(currency_id);
    $(".currency-select").eq(1).val(currency_id);
  });

  $(".card-select").on("change", function () {
    let currency_id = $(".card-select option:selected").data("currency");
    console.log(currency_id);
    $(".currency-select").val(currency_id);
  });
});
