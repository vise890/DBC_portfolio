$(document).ready(function() {

  function bindEvents() {
    $('.toolbox .add').on('click', function() {
      addTodo();
    });

    $('.todo_list').on('click', 'a.delete, a.complete', function(e) {

      e.preventDefault();

      var todo = $(event.target).parents('.todo');
      var action = $(event.target).attr('class').toLowerCase();

      switch(action) {
        case 'delete':
          deleteTodo(todo);
          break;
        case 'complete':
          completeTodo(todo);
          break;
       }

    });
  }

  function addTodo() {
    var todoName = $('input.todo').val();
    $('input.todo').val('');

    if(todoName != '') {
      var todo = buildTodo(todoName);
      $('.todo_list').append(todo);
    }
  };

  function deleteTodo(todo) {
    todo.remove();
  };

  function completeTodo(todo) {
    todo.attr('class', 'complete todo');
  };

  var todoTemplate = $.trim($('#todo_template').html());
  function buildTodo(todoName) {
    var $todo = $(todoTemplate);
    $todo.find('h2').text(todoName);
    return $todo;
  }

  bindEvents();

});
