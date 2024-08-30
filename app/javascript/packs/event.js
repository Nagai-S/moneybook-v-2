$(function () {
  $(".account-select").on("change", function () {
    let currency_id = $(".account-select option:selected").data("currency");
    console.log(currency_id);
    $(".currency-select").val(currency_id);
  });

  $(".account-select").eq(2).on("change", function () {
    let currency_id = $(".account-select option:selected").eq(2).data("currency");
    console.log(currency_id);
    $(".currency-select").eq(2).val(currency_id);
  });

  $(".card-select").on("change", function () {
    let currency_id = $(".card-select option:selected").data("currency");
    console.log(currency_id);
    $(".currency-select").val(currency_id);
  });

  $(".card-select").eq(2).on("change", function () {
    let currency_id = $(".card-select option:selected").eq(2).data("currency");
    console.log(currency_id);
    $(".currency-select").eq(2).val(currency_id);
  });
});
