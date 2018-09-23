
$( document ).ready(function() {
    $('#add_friend_button').click(function() {
      var data = {};
      data['friend'] = $('#friend_to_add').val();

      $.post('/experts/' + $('#expert_id').val() + '/add_friend', data);
    })

    $('#find_friend_button').click(function() {
      var subject = encodeURIComponent(($('#friend_subject_to_add').val()).trim());
      $.get('/experts/' + $('#expert_id').val() + '/find_friend?subject=' + subject, writeOutPath);
    })
});

function writeOutPath(path) {
  $('#path-body').html('');
  path.forEach(function(element, index){
      $('#path-body').append(element);
      if (index != (path.length -1)) {
        $('#path-body').append(" -> ");
      }
  });

  $('#path_modal').modal('show')
}
