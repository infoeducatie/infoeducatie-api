(function ($) {
  "use strict";

  var screenshotInsertInstalled = false;

  function installScreenshotInsertFields() {
    if (screenshotInsertInstalled || !window.nestedFormEvents) return;

    var originalInsertFields = window.nestedFormEvents.insertFields;

    window.nestedFormEvents.insertFields = function (content, association, link) {
      var target = $(link).data("target");
      var isScreenshotEditor =
        association === "screenshots" && $(link).data("screenshot-add");

      if (isScreenshotEditor && target) {
        return $(content).appendTo($(target));
      }

      return originalInsertFields.call(window.nestedFormEvents, content, association, link);
    };

    screenshotInsertInstalled = true;
  }

  function refreshScreenshotEditor(editor) {
    var $editor = $(editor);
    var $cards = $editor.find("> [data-screenshot-items] > .fields");
    var activeCards = $cards.not(".is-removed").length;

    $editor.find("> [data-screenshot-empty]").toggle(activeCards === 0);
  }

  function prepareScreenshotCard(field) {
    var $field = $(field);
    var $destroyInput = $field.find("[data-screenshot-destroy]");

    $field.removeClass("tab-pane").addClass("ie-screenshot-editor__item").show();
    $field.toggleClass("is-removed", $destroyInput.val() === "1");
    refreshScreenshotEditor($field.closest("[data-screenshot-editor]"));
  }

  function initializeScreenshotEditors(scope) {
    var $scope = $(scope || document);
    var $editors = $scope.find("[data-screenshot-editor]").add(
      $scope.filter("[data-screenshot-editor]")
    );

    installScreenshotInsertFields();
    $editors.each(function () {
      var $editor = $(this);
      $editor.find("> [data-screenshot-items] > .fields").each(function () {
        prepareScreenshotCard(this);
      });
      refreshScreenshotEditor($editor);
    });
  }

  function setRichTextStatus(editor, message, isError) {
    var status = editor
      .closest("[data-rich-text-editor]")
      .querySelector("[data-rich-text-status]");

    if (!status) return;
    status.textContent = message;
    status.classList.toggle("is-error", Boolean(isError));
  }

  function uploadRichTextImage(editor, attachment) {
    var file = attachment.file;
    var uploadUrl = editor.getAttribute("data-upload-url");
    var csrfToken = document.querySelector('meta[name="csrf-token"]');

    if (!file || !file.type.match(/^image\/(jpeg|png|webp)$/) || !uploadUrl) {
      attachment.remove();
      setRichTextStatus(editor, "Use a JPEG, PNG or WebP image.", true);
      return;
    }

    var body = new FormData();
    body.append("image", file);
    attachment.setUploadProgress(5);
    setRichTextStatus(editor, "Uploading image...", false);

    fetch(uploadUrl, {
      method: "POST",
      credentials: "same-origin",
      headers: {
        "Accept": "application/json",
        "X-CSRF-Token": csrfToken ? csrfToken.content : ""
      },
      body: body
    })
      .then(function (response) {
        return response.json().then(function (payload) {
          if (!response.ok) throw new Error(payload.error || "Upload failed");
          return payload;
        });
      })
      .then(function (payload) {
        attachment.setAttributes({ url: payload.url, href: payload.url });
        attachment.setUploadProgress(100);
        setRichTextStatus(editor, "Image uploaded.", false);
      })
      .catch(function (error) {
        attachment.remove();
        setRichTextStatus(editor, error.message || "Image upload failed.", true);
      });
  }

  function initializeRichTextEditors(scope) {
    var root = scope || document;
    var editors = Array.prototype.slice.call(
      root.querySelectorAll ? root.querySelectorAll("[data-rich-text-input]") : []
    );

    if (root.matches && root.matches("[data-rich-text-input]")) editors.push(root);

    editors.forEach(function (editor) {
      if (editor.getAttribute("data-rich-text-ready") === "true") return;

      editor.setAttribute("data-rich-text-ready", "true");
      editor.addEventListener("trix-attachment-add", function (event) {
        event.stopPropagation();
        uploadRichTextImage(editor, event.attachment);
      });
    });
  }

  $(document).on("nested:fieldAdded:screenshots", "form", function (event) {
    var $field = $(event.field);
    if (!$field.closest("[data-screenshot-editor]").length) return;

    prepareScreenshotCard($field);
  });

  $(document).on("change", "[data-screenshot-file]", function () {
    var input = this;
    var file = input.files && input.files[0];
    if (!file) return;

    var $card = $(input).closest(".fields");
    var $image = $card.find("[data-screenshot-image]");
    var reader = new FileReader();

    reader.onload = function (event) {
      $image.attr("src", event.target.result).show();
      $card.find("[data-screenshot-placeholder]").hide();
    };

    reader.readAsDataURL(file);
    $card.find("[data-screenshot-filename]").text(file.name).attr("title", file.name);
    $card.find("[data-screenshot-status]").text("Ready to upload when you save");
    $card.find("[data-screenshot-upload-label]").text("Change image");
  });

  $(document).on("click", "[data-screenshot-remove]", function () {
    var $field = $(this).closest(".fields");
    $field.find("[data-screenshot-destroy]").val("1");
    $field.addClass("is-removed");
    refreshScreenshotEditor($field.closest("[data-screenshot-editor]"));
  });

  $(document).on("click", "[data-screenshot-undo]", function () {
    var $field = $(this).closest(".fields");
    $field.find("[data-screenshot-destroy]").val("0");
    $field.removeClass("is-removed");
    refreshScreenshotEditor($field.closest("[data-screenshot-editor]"));
  });

  $(function () {
    initializeScreenshotEditors(document);
    initializeRichTextEditors(document);
  });

  document.addEventListener("rails_admin.dom_ready", function (event) {
    initializeScreenshotEditors(event.detail || document);
    initializeRichTextEditors(event.detail || document);
  });
})(jQuery);
