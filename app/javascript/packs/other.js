var currentNumOtherValueInputs = 0;
var lastEqualValue = 0;

document.querySelector('#paymentMethod').addEventListener('change', function() {
  var selectedValue = this.value;
  var btnSubmit = document.querySelector('#btnSubmit');

  if (selectedValue == 'Outros') {
    btnSubmit.classList.remove('d-none');
  } else {
    btnSubmit.classList.add('d-none');
    removeAllFields();
    currentNumOtherValueInputs = 0;
    lastEqualValue = 0;
    setTimeout(updateOtherValues, 0);
  }
});

function removeAllFields() {
  var fields = document.querySelectorAll('.nested-fields');
  fields.forEach(function(field) {
    field.parentNode.removeChild(field);
  });
}

function updateOtherValues() {
  var total = parseFloat(document.querySelector('#total-price-input').value);
  var otherValueInputs = document.querySelectorAll('.other-value-input');
  var numOtherValueInputs = currentNumOtherValueInputs;

  if (numOtherValueInputs > 0) {
    var equalValue = total / numOtherValueInputs;
    lastEqualValue = equalValue;

    otherValueInputs.forEach(function(input) {
      input.value = equalValue.toFixed(2);
    });
  } else {
    otherValueInputs.forEach(function(input) {
      input.value = lastEqualValue.toFixed(2);
    });
  }
}

var container = document.querySelector('#others_for_sales');
container.addEventListener('click', function(e) {
  if (e.target && e.target.classList.contains('remove_fields')) {
    e.preventDefault();
    e.stopPropagation();

    currentNumOtherValueInputs--;

    var field = e.target.closest('.nested-fields');
    field.parentNode.removeChild(field);

    setTimeout(updateOtherValues, 0);
  }
});

var addButton = document.querySelector('.add_fields');
if (addButton) {
  addButton.addEventListener('click', function() {
    currentNumOtherValueInputs++;
    setTimeout(updateOtherValues, 0);
  });
}

document.querySelector('#total-price-input').addEventListener('input', function() {
  setTimeout(updateOtherValues, 0);
});

updateOtherValues();
