function lookupURL() {
  if ($("#folderurl").val() == 0) {
    $("#progress").html('stop being retarded');
  }
  else {
    $("#progress").html('');
    $.get("/minus/new?folderurl=" + $("#folderurl").val(), function(data) {
      $("#progress").html(data);
    });
  }
}

function downloadFolders() {
}

$("#submiturl").click(function() {
  lookupURL();
});

$("#folderurl").bind('keypress', function(e) {
  if (e.keyCode == 13) {
    event.preventDefault();
    lookupURL();
  }
});
