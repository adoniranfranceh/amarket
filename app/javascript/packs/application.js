// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import "bootstrap"
import "bootstrap-icons/font/bootstrap-icons.css"
import $ from 'jquery';
import 'jquery-mask-plugin';
import Swal from 'sweetalert2/dist/sweetalert2.js'
import 'sweetalert2/src/sweetalert2.scss'
window.Swal = Swal
import "@nathanvda/cocoon"

$(document).ready(function() {
  $('.price-input').mask("#.##0,00", {reverse: true});
  $('.phone').mask('(00) 0 0000-0000');
  $('.cpf-input').mask('000-000.000-00');

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
            Swal.fire({
              icon: 'error',
              title: 'Oops...',
              text: errorMessages
            })
            $('.required-field').removeClass('required-field-error');
            $('.error-message').empty();

            $('.required-field').each(function() {
              if ($.trim($(this).val()) === '') {
                $(this).addClass('required-field-error');
                $(this).siblings('.error-message').remove();

                var errorMessage = 'Este campo é obrigatório.';
                $(this).after('<div class="error-message">' + errorMessage + '</div>');
              }
            $('.required-field').on('click', function() {
              $(this).removeClass('required-field-error');
              $(this).siblings('.error-message').remove();
            });
            });
            var errorMessagesElement = $('#error-messages');
            errorMessagesElement.empty();
            errorMessagesElement.text(JSON.stringify(errorMessages));
          }
        }
      }
    });
  }
}

Rails.start()
Turbolinks.start()
ActiveStorage.start()
