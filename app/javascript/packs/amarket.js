$(document).ready(function() {
  $('#submit-button').click(function(event) {
    event.preventDefault();
    checkRequiredFields();
  });
});

function checkRequiredFields() {
  var allFieldsFilled = true;

  $('.required-field').each(function() {
    if ($.trim($(this).val()) === '') {
      allFieldsFilled = false;
      $(this).addClass('required-field-error');
      $(this).siblings('.error-message').text('Este campo é obrigatório.');
      $(this).after('<div class="error-message">Este campo é obrigatório.</div>');
    }
  });

  if (allFieldsFilled) {
    $('form').submit();
  } else {
    $.ajax({
      url: '/admin_template/sales',
      type: 'POST',
      data: $('form').serialize(),
      dataType: 'json',
      success: function(data) {},
      error: function(xhr, status, error) {
        console.error('Ocorreu um erro ao enviar o formulário.', error);

        if (xhr.status === 422) {
          var response = JSON.parse(xhr.responseText);
          if (response && response.errors) {
            var errorMessages = response.errors;
            console.log(errorMessages);

            var errorList = '<ul>';
            errorMessages.forEach(function(message) {
              errorList += '<li>' + message + '</li>';
            });
            errorList += '</ul>';

            Swal.fire({
              icon: 'error',
              title: 'Oops...',
              html: errorList
            });

            $('.required-field').removeClass('required-field-error');
            $('.error-message').remove();
            $('.required-field').each(function() {
              if ($.trim($(this).val()) === '') {
                $(this).addClass('required-field-error');
                $(this).after('<div class="error-message">Este campo é obrigatório.</div>');
              }
            });

            var errorMessagesElement = $('#error-messages');
            errorMessagesElement.empty();
            errorMessagesElement.html(errorList);
          }
        }
      }
    });
  }
}
