$(document).ready(function() {
  function hideShowQuantityFields() {
    $('.variation').each(function() {
      var $this = $(this);
      var subgroupsPresent = $this.find('.subgroup').length;

      if (subgroupsPresent > 0) {
        $this.find('.variation-quantity').hide();
      } else {
        $this.find('.variation-quantity').show();
      }
    });

    var variationsPresent = $('.variation').length;
    var subgroupsPresent = $('.subgroup').length;

    console.log('Variations Present:', variationsPresent);
    console.log('Subgroups Present:', subgroupsPresent);

    if (variationsPresent === 0) {
      $('.div-quantity').show();
      console.log('Show div-quantity');
    } else {
      $('.div-quantity').hide();
    }

    if (subgroupsPresent === 0) {
      $('.variation-quantity').show();
      console.log('Show variation-quantity');
    }
  }

  $(document).on('click', '.add-variation, .remove-variation, .add-subgroup, .rm-subgroup', function() {
    setTimeout(function() {
      hideShowQuantityFields();
    }, 100);
  });

  $('a[data-toggle="modal"]').click(function() {
    var imageUrl = $(this).find('img').attr('src');
    $('#exampleModal').find('.img-modal').attr('src', imageUrl);
  });

  $('#exampleModal').on('show.bs.modal', function() {
    var imageUrl = $(this).find('img').attr('src');
    $(this).find('.img-modal').attr('src', imageUrl);
  });

  $('#exampleModal').on('hidden.bs.modal', function() {
    $(this).find('.img-modal').attr('src', '');
  });

  // Esconder os campos corretamente no carregamento da página
  hideShowQuantityFields();
});
