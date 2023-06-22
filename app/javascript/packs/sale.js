$(function() {
  var products = JSON.parse($('#product-data').val());

  $('#product-search').on('input', function() {
    var searchTerm = $(this).val();

    $.ajax({
      url: '/search',
      method: 'GET',
      data: {
        term: searchTerm
      },
      success: function(data) {
        var productList = $('#search-results');
        productList.empty();

        $.each(data, function(index, product) {
          var listItem = $('<div>').text(product.name).data('price', product.sale_price);
          productList.append(listItem);
        });
      },
      error: function() {
        // Tratar erros, se necessário
      }
    });
  });

  $('#search-results').on('click', 'div', function() {
    var productName = $(this).text();
    var productPrice = $(this).data('price');

    var card = $('<div>').addClass('product-card');
    card.append($('<h4>').text(productName));
    card.append($('<p>').text('Preço: R$' + productPrice));
    card.append($('<input>').attr('type', 'number').addClass('quantity').val(1));
    card.append($('<button>').text('Remover').addClass('remove-btn'));

    var row = $('<tr>');
    row.append($('<td>').text(''));
    row.append($('<td>').text(productName));
    row.append($('<td>').text('R$' + productPrice));
    row.append($('<td>').append(card));

    $('#product-table tbody').append(row);

    updateTotal();
  });

  $('#product-table').on('click', '.remove-btn', function() {
    $(this).closest('tr').remove();
    updateTotal();
  });

  $('#product-table').on('input', '.quantity', function() {
    var quantity = $(this).val();
    var price = $(this).closest('tr').find('td:nth-child(3)').text().replace('R$', '').trim();
    var totalPrice = parseFloat(quantity) * parseFloat(price);
    $(this).closest('tr').find('.row-total span').text('R$' + totalPrice.toFixed(2));

    updateTotal();
  });

  var originalQuantities = {}; // Armazena as quantidades originais de cada produto

  $('#quantity-duplicate').on('input', function() {
    var duplicateQuantity = parseInt($(this).val());
    if (isNaN(duplicateQuantity) || duplicateQuantity <= 0) {
      return;
    }

    var $productRows = $('#product-table tbody tr');

    $productRows.each(function() {
      var $quantityInput = $(this).find('.quantity');
      var productName = $(this).find('td:nth-child(2)').text();
      var originalQuantity = originalQuantities[productName];
      if (originalQuantity === undefined) {
        originalQuantity = parseFloat($quantityInput.val());
        originalQuantities[productName] = originalQuantity;
      }
      var newQuantity = originalQuantity * duplicateQuantity;
      var $rowTotalSpan = $(this).find('.row-total span');

      $quantityInput.val(newQuantity);
      $rowTotalSpan.text('R$' + (newQuantity * parseFloat($(this).find('td:nth-child(3)').text().replace('R$', '').trim())).toFixed(2));
    });

    updateTotal();
  });

  $('#discount-input').on('input', function() {
    updateTotal();
  });

  // Atualiza a quantidade dos itens ao carregar a página
  $('#product-table tbody tr').each(function() {
    var productName = $(this).find('td:nth-child(2)').text();
    var quantity = parseFloat($(this).find('.quantity').val());
    originalQuantities[productName] = quantity;
  });

  function updateTotal() {
    var total = 0;
    $('#product-table tbody tr').each(function() {
      var quantity = parseFloat($(this).find('.quantity').val());
      var price = parseFloat($(this).find('td:nth-child(3)').text().replace('R$', '').trim());
      var subtotal = quantity * price;
      if (!isNaN(subtotal)) {
        total += subtotal;
      }
    });

    var discount = parseFloat($('#discount-input').val());
    if (!isNaN(discount)) {
      var discountAmount = total * (discount / 100);
      total -= discountAmount;
    }

    $('#total-price-input').val(total.toFixed(2));
    $('tfoot .row-total span').text('R$' + total.toFixed(2));
  }
});
