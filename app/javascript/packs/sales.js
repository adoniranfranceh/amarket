$(document).ready(function () {
  var products = JSON.parse($('#product-data').val());
  var quantities = {};

  $('#product-search').on('input', function () {
    var searchTerm = $(this).val();

    $.ajax({
      url: '/search',
      method: 'GET',
      data: { term: searchTerm },
      success: function (data) {
        var productList = $('#search-results');
        productList.empty();

        if (data.length === 0) {
          productList.append($('<tr>').append($('<td colspan="5">').addClass('text-center').text('Nenhum produto encontrado')));
          return;
        }

        $.each(data, function (index, product) {
            var salePrice = parseFloat(product.sale_price.replace(',', '.'));
            var formattedPrice = salePrice.toFixed(2).replace('.', ',');

            var addButton = (product.quantity > 0) ?
                $('<button>').addClass('btn btn-success add-btn').text('Add').attr('type', 'button').data('id', product.id).data('price', salePrice).data('image', product.image_url).data('quantity', product.quantity) :
                $('<button>').addClass('btn btn-secondary').text('Produto não disponível').attr('disabled', 'disabled');

            var productRow = $('<tr>').append(
                $('<td>').text(product.id),
                $('<td>').text(product.name + (product.brand ? ' - ' + product.brand : '')),
                $('<td>').text('R$ ' + formattedPrice), // Usando a versão formatada do preço
                $('<td>').append(product.image_url ? $('<img class="image-t-no-hover">').attr('src', product.image_url) : null),
                $('<td>').append(addButton)
            );

            productRow.data({ id: product.id, price: salePrice });
            productList.append(productRow);
        });
      },
      error: function () { }
    });
  });

  $('#search-results').on('click', '.add-btn', function () {
    var productId = $(this).data('id');
    var existingRow = $('#product-table tbody').find('tr[data-id="' + productId + '"]');

    if (existingRow.length > 0) {
      var quantityInput = existingRow.find('.quantity');
      var newQuantity = parseInt(quantityInput.val()) + 1;
      var maxQuantity = parseInt(quantityInput.attr('max'));

      if (newQuantity > maxQuantity) {
        Swal.fire({
          icon: 'error',
          title: 'Limite excedido',
          text: 'A quantidade disponível em estoque é ' + maxQuantity
        });

        newQuantity = maxQuantity;
      }

      quantityInput.val(newQuantity);
      var totalPrice = parseFloat(existingRow.find('td:nth-child(4)').text().replace('R$ ', '').replace('.', ',').trim()) * newQuantity;
      existingRow.find('.row-total span').text('R$ ' + totalPrice.toFixed(2).replace('.', ','));
      updateTotal();
      return;
    }

    var productName = $(this).closest('tr').find('td:nth-child(2)').text();
    var productPrice = parseFloat($(this).closest('tr').data('price')).toFixed(2);
    var productImageURL = $(this).data('image');

    var cardQuantityInput = $('<input>').prop({
      type: 'number',
      min: 1,
      max: $(this).data('quantity')
    }).addClass('quantity form-control input-number').val(1).attr('name', 'quantity_for_product' + productId);

    var card = $('<div>').addClass('product-card');
    card.append($('<h4>').text(productName));
    card.append($('<p>').text('Preço: R$ ' + productPrice.replace('R$ ', '').replace('.', ',')));
    card.append(cardQuantityInput);
    card.append($('<button>').text('Remover').addClass('remove-btn btn btn-danger'));

    var row = $('<tr>').attr('data-id', productId);
    row.append($('<td>').text(productId));
    row.append($('<td>').text(productName));
    row.append($('<td>').append($('<img class="image-t-no-hover">').attr('src', productImageURL)));
    row.append($('<td>').text('R$ ' + productPrice.replace('.', ',')));
    row.append($('<td>').append(card));

    $('#product-table tbody').append(row);
    addProductId(productId);

    var quantityInput = cardQuantityInput;
    var quantity = parseInt(quantityInput.val());
    quantities[productId] = quantity;

    cardQuantityInput.on('input', function () {
      quantities[productId] = parseInt($(this).val());
      var quantity = $(this).val();
      var totalPrice = parseFloat(productPrice) * parseInt(quantity);
      card.find('p').text('Preço: R$ ' + totalPrice.toFixed(2).replace('.', ','));
      updateTotal();
    });

    updateTotal();
  });

  $('#product-table').on('click', '.remove-btn', function () {
    var productId = $(this).closest('tr').find('td:first-child').text();
    removeProductId(productId);

    $(this).closest('tr').remove();
    delete quantities[productId];
    updateTotal();
  });

  $('#product-table').on('input', '.quantity', function () {
    var quantity = $(this).val();
    var price = $(this).closest('tr').find('td:nth-child(3)').text().replace('R$ ', '').replace('.', ',').trim();
    var totalPrice = parseFloat(quantity) * parseFloat(price);
    $(this).closest('tr').find('.row-total span').text('R$ ' + totalPrice.toFixed(2).replace('.', ','));
    updateTotal();
  });

  var originalQuantities = {};

  $('#discount-input').on('input', function () {
    updateTotal();
  });

  $('#taxes-input').on('input', function () {
    updateTotal();
  });

  $('#product-table tbody tr').each(function () {
    var productName = $(this).find('td:nth-child(2)').text();
    var quantity = parseFloat($(this).find('.quantity').val());
    originalQuantities[productName] = quantity;
  });

  function updateTotal() {
    var total = 0;
    var totalQuantity = 0;

    $('#product-table tbody tr').each(function () {
      var quantity = parseInt($(this).find('.quantity').val(), 10);
      var price = parseFloat($(this).find('td:nth-child(4)').text().replace('R$ ', '').replace(',', '.').trim());
      var subtotal = quantity * price;

      if (!isNaN(subtotal)) {
        total += subtotal;
        totalQuantity += quantity;
      }
    });

    $('#total-quantity-input').val(totalQuantity);

    var discount = parseFloat($('#discount-input').val());
    if (!isNaN(discount)) {
      var discountAmount = total * (discount / 100);
      total -= discountAmount;
    }

    var taxes = parseFloat($('#taxes-input').val());
    if (!isNaN(taxes)) {
      var taxesAmount = total * (taxes / 100);
      total += taxesAmount;
    }

    var formattedTotal = total.toFixed(2);
    $('#total-price-input').val(formattedTotal);
    $('#customer_value').val(formattedTotal);
    $('tfoot .row-total span').text('R$ ' + formattedTotal.replace('.', ','));

    $('#change-input').val('0,00');

    $('#customer_value').on('input', function () {
      var customerValue = parseFloat($(this).val().replace(',', '.'));
      if (!isNaN(customerValue)) {
        var changeAmount = customerValue - total;
        $('#change-input').val(changeAmount.toFixed(2));
      } else {
        $('#change-input').val('0,00');
      }
    });
  }

  function addProductId(productId) {
    var productIds = getProductIds();
    if (!productIds.includes(productId)) {
      productIds.push(productId);
      updateProductIds(productIds);
      updateHiddenProductIds(productIds)
    }
  }

  function removeProductId(productId) {
    var productIds = getProductIds();
    var index = productIds.indexOf(productId);
    if (index !== -1) {
      productIds.splice(index, 1);
      updateProductIds(productIds);
      updateHiddenProductIds(productIds)
    }
  }

  function getProductIds() {
    var productIds = [];
    var productIdsValue = $('#product-id-list').val();
    if (productIdsValue) {
      productIds = productIdsValue.split(',');
    }
    return productIds;
  }

  function updateProductIds(productIds) {
    $('#product-id-list').val(productIds.join(','));
  }

  function updateHiddenProductIds(productIds) {
    $('#product-id-list').val(productIds.join(','));
  }
});
