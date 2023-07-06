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
import "@nathanvda/cocoon"

$(document).ready(function() {
  $('.price-input').mask("#.##0,00", {reverse: true});
  $('.phone').mask('(00) 0 0000-0000');
  $('.cpf').mask('000-000.000-00');
});

Rails.start()
Turbolinks.start()
ActiveStorage.start()
