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
          var productRow = $('<tr>');
          var productId = $('<td>').text(product.id);
          var productName = $('<td>').text(product.name + (product.brand ? '' + product.brand : ''));
          var productPrice = $('<td>').text('R$' + product.sale_price);
          var productImage = $('<td>');
          if (product.image_url) {
            var imageTag = $('<img class="image-t">').attr('src', product.image_url);
            productImage.append(imageTag);
          } else {
            var defaultImage = $('<img class="image-t">').attr('src', '/assets/no_image-d69820241ecbe31d0cb4eb23f503b82956340cea7fe0fc6d74ebdfe45bd326d3.png');
            productImage.append(defaultImage);
          }

          var addButton;
          if (product.quantity > 0) {
            addButton = $('<td>').append($('<button>').addClass('btn btn-success').text('Add').attr('type', 'button').data('price', product.sale_price).data('image', product.image_url).data('quantity', product.quantity));
          } else {
            addButton = $('<td>').text('Produto não disponível');
          }
          productRow.append(productId ,productName, productPrice, productImage, addButton);
          productRow.data({
            id: product.id,
            price: product.sale_price
          });

          productList.append(productRow);
        });

      },
      error: function() {
      }
    });
  });

  $('#search-results').on('click', 'button', function() {
    var productName = $(this).closest('tr').find('td:nth-child(2)').text();
    var productId = $(this).closest('tr').data('id');
    var productPrice = $(this).closest('tr').data('price');
    var productImageURL = $(this).data('image');

    var cardQuantityInput = $('<input>').prop({
      type: 'number',
      min: 1,
      max: $(this).data('quantity')
    }).addClass('quantity').val(1);
    var card = $('<div>').addClass('product-card');
    card.append($('<h4>').text(productName));
    card.append($('<p>').text('Preço: R$' + productPrice));
    card.append(cardQuantityInput);
    card.append($('<button>').text('Remover').addClass('remove-btn btn btn-danger'));

    var row = $('<tr>');
    row.append($('<td>').text(productId));
    row.append($('<td>').text(productName));
    row.append(productImageURL ? $('<td>').append($('<img class="image-t">').attr('src', productImageURL)) : $('<td>').append($('<img class="image-t">').attr('src', '/assets/no_image-d69820241ecbe31d0cb4eb23f503b82956340cea7fe0fc6d74ebdfe45bd326d3.png')));
    row.append($('<td>').text('R$' + productPrice));
    row.append($('<td>').append(card));

    $('#product-table tbody').append(row);
    addProductId(productId);

    cardQuantityInput.on('input', function() {
      var quantity = $(this).val();
      var totalPrice = parseFloat(productPrice) * parseInt(quantity);
      card.find('p').text('Preço: R$' + totalPrice.toFixed(2));
      updateTotal();
    });

    updateTotal();
  });

  function appendProductImage(container, imageUrl) {
    if (imageUrl) {
      var imageTag = $('<img class="image-t">').attr('src', imageUrl);
      container.append(imageTag);
    } else {
      var defaultImage = $('<img class="image-t">').attr('src', '/assets/no_image-d69820241ecbe31d0cb4eb23f503b82956340cea7fe0fc6d74ebdfe45bd326d3.png');
      container.append(defaultImage);
    }
  }

  $('#product-table').on('click', '.remove-btn', function() {
    var productId = $(this).closest('tr').find('td:first-child').text();
    removeProductId(productId);

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

  var originalQuantities = {};

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
      var price = parseFloat($(this).find('td:nth-child(4)').text().replace('R$', '').trim());
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


  function addProductId(productId) {
    var productIds = getProductIds();
    if (!productIds.includes(productId)) {
      productIds.push(productId);
      updateProductIds(productIds);
    }
  }

  function removeProductId(productId) {
    var productIds = getProductIds();
    var index = productIds.indexOf(productId);
    if (index !== -1) {
      productIds.splice(index, 1);
      updateProductIds(productIds);
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
});
