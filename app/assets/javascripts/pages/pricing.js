function Cart() {
  this.products = {}
  this.items =  {}
  this.bindEvents()
}

Cart.prototype.bindEvents = function () {
  var self = this
  $('.pricing input.checkbox:checked').attr('checked', false)
  $('.pricing input.checkbox').click(function(){
    var flag = $(this).is(':checked')
    var productId = $(this).data('product')
    console.log(flag)
    if(flag){
      self.items[productId] = self.products[productId]
      self.addItem(productId, self.items[productId])
    }else{
      delete self.items[productId]
      self.deleteItem(productId)
    }
  })
  $('.cart-items .btn-cart-checkout').click(function(){
    if(!$.isEmptyObject(self.items)){
      var productIds = []
      $.each(self.items, function(productId){
        productIds[productIds.length] = productId
      })
      window.location.href = '/subscriptions/new?product_ids=' + productIds.join(',')
    }else{
      alert('Please add a package to your cart.')
    }
    return false;
  })
}

Cart.prototype.addItem = function (productId, productDetails) {
  var html = '<tr class="cart-item-' + productId + '">'
  html += '<th>'
  html += productDetails.title
  html += '</th>'
  html += '<td>'
  html += '$' +productDetails.price
  html += '</td>'
  html += '</tr>'
  var subTotalEl = $('.cart-items .cart-total')
  $(html).insertBefore(subTotalEl)
  subTotalEl.find('.amount').text('$' + this.subTotal())
}

Cart.prototype.deleteItem = function(productId){
  $('.cart-items .cart-item-' +productId).remove()
  $('.cart-itemss .cart-total .amount').text('$' + this.subTotal())
};

Cart.prototype.subTotal = function(){
  var subTotal = 0
  $.each(this.items, function(productId, details){
    subTotal = subTotal + details.price
  })
  return subTotal
}
