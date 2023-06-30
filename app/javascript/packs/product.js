$(function() {
  $('.btn-variation').on('click', function() {
    var variationFields = $('.variation-fields:first').clone();
    variationFields.find('input').val('');
    $('.card').append(variationFields);
  });

  $('.card').on('click', '.remove-btn', function() {
    $(this).closest('.variation-fields').remove();
  });
});


