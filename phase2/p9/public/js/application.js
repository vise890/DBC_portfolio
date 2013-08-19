$(document).ready(function() {

  setBackgroundColor();

  function getBackgroundColor() {
    var color = $.cookie('color');
    // color ? color = color : color = 'white'
    // letting it return null if cookie is not set may be better..
    // (preserves settings from css)
    return color;
  }

  function setBackgroundColor() {
    backgroundColor = getBackgroundColor();
    $('body').css('background-color', backgroundColor);
  };

  $('#set_color').submit(function(e) {

   e.preventDefault();

   setFavoriteColor(getFavoriteColor());

   setBackgroundColor();

   function setFavoriteColor(color) {
     $.cookie('color', color, {
       path: '/'
     });
   };

   function getFavoriteColor() {
     var color = $('#color').val();
     $('#color').val('');

     return color;
   };

 });

  //////////////////////////////////////////////////
  //////////////////////////////////////////////////
  //////////////////////////////////////////////////

  $('.awesomeness_teller').on('click', function(e) {

    var awesomeness = $(e.target).attr('data-heading');
    $('#awesomeness_holder').text(awesomeness);

  });

  $('.skill_teller').on('click', function() {

    function getSkill() {
      var urlTokens = window.location.toString().split('/');
      var skill = $(urlTokens).last();
      return skill[0];
    };

    function setSkill(skill) {
      $('#skill_holder').text(skill);
    }

    setSkill(getSkill());

  });

  $('.meal_teller').on('click', function() {

    function getRandomMeal(meals) {
      var randomIndex = Math.floor(Math.random() * meals.length)
      return meals[randomIndex]
    };

    var randomMeal = getRandomMeal(meals);
    $('#meal_holder').text(randomMeal);

  });

});
