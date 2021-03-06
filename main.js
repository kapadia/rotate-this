// Generated by CoffeeScript 1.6.3
(function() {
  var User, comparison, currentSubjects, getSubject, onClassification, postClassification, setupLogin, subject1, subject2, subjects;

  User = null;

  subject1 = null;

  subject2 = null;

  subjects = null;

  comparison = null;

  currentSubjects = null;

  getSubject = function() {
    return $.get("gettwo", function(data) {
      var s1, s2;
      if (Math.random() < 0.5) {
        s1 = data[0];
        s2 = data[1];
      } else {
        s2 = data[0];
        s1 = data[1];
      }
      subject1.attr("src", s1.location);
      subject1.attr("data-id", s1._id);
      subject2.attr("src", s2.location);
      subject2.attr("data-id", s2._id);
      currentSubjects = data;
      comparison.removeClass("hide");
      return subjects.on("click", onClassification);
    });
  };

  postClassification = function() {
    return console.log('postClassification');
  };

  onClassification = function() {
    var classification, el, id, s1, s2;
    subjects.off("click", onClassification);
    el = $(this).find("img.subject");
    id = el.attr("data-id");
    s1 = currentSubjects.shift();
    s2 = currentSubjects.shift();
    classification = {
      subject1: s1["_id"],
      subject2: s2["_id"],
      selected: id,
      expert_id: User.current.id,
      expert_name: User.current.name
    };
    return $.post("classification", classification).done(function() {
      return getSubject();
    });
  };

  setupLogin = function() {
    var api, topBar;
    api = new zooniverse.Api({
      project: 'rotate-this',
      host: "https://dev.zooniverse.org",
      path: '/proxy'
    });
    topBar = new zooniverse.controllers.TopBar;
    topBar.el.appendTo('body');
    User.on("change", function() {
      if (User.current) {
        return getSubject();
      } else {
        return comparison.addClass("hide");
      }
    });
    if (!User.current) {
      return zooniverse.controllers.loginDialog.show();
    }
  };

  $(document).ready(function() {
    subject1 = $("#subject1");
    subject2 = $("#subject2");
    comparison = $("#comparison");
    subjects = $("div.image");
    return $.getScript("lib/zooniverse.js", function() {
      User = zooniverse.models.User;
      return setupLogin();
    });
  });

}).call(this);

/*
//@ sourceMappingURL=main.map
*/
