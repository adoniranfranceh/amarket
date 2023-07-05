$(document).ready(function() {
  // Função para atualizar a quantidade do produto
  function updateProductQuantity() {
    var totalQuantity = 0;

    // Iterar pelos campos de quantidade dos subgrupos
    $('.quantity').each(function() {
      var subgroupQuantity = parseInt($(this).val()) || 0; // Obter o valor do campo de quantidade do subgrupo
      totalQuantity += subgroupQuantity; // Somar a quantidade ao total
    });

    // Atualizar o valor do campo de quantidade do produto
    $('#product-quantity').val(totalQuantity);

  }

  // Manipular eventos de mudança nos campos de quantidade dos subgrupos
  $(document).on('change', '.quantity', function() {
    updateProductQuantity(); // Chamar a função de atualização do produto
  });

  // Manipular evento de remoção de subgrupo
  $(document).on('click', '.remove', function() {
    $(this).closest('.nested-fields').remove(); // Remover o subgrupo do DOM
    updateProductQuantity(); // Chamar a função de atualização do produto
  });

  $(document).on('click', '.add-variation', function() {
    // Adicionar a classe "disabled-form" ao input de quantidade do produto
    $('#product-quantity').addClass('disabled-form');
  });

  // Manipular evento de remover variação
  $(document).on('click', '.remove-variation', function() {
    // Remover a classe "disabled-form" do input de quantidade do produto
    $('#product-quantity').removeClass('disabled-form');
  });

  // Chamar a função de atualização do produto inicialmente
  updateProductQuantity();

  $(document).on('click', '.add-subgroup', function() {

    var subgroupsPresent = $('.nested-fields').length > 0;
    if (subgroupsPresent) {
      $('.variation-quantity').hide().val(0);
      $('#product-quantity').val(0);
    }
  });

  $(document).on('click', '.rm-subgroup', function() {
    var subgroupsPresent = $('.card-primary').length === 0;
    if (subgroupsPresent) {
      $('.variation-quantity').show();
    }
  });

  $('a[data-toggle="modal"]').click(function() {
    var imageUrl = $(this).find('img').attr('src');
    $('#exampleModal').find('img').attr('src', imageUrl);

     $('#exampleModal').on('shown.bs.modal', function() {
      $(this).find('.img-modal').attr('src', imageUrl);
    });

    $('#exampleModal').on('hidden.bs.modal', function() {
      $(this).find('.img-modal').attr('src', '');
    });
  });

});
