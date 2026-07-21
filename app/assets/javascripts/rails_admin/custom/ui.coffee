$ = jQuery

installScreenshotInsertFields = ->
  originalInsertFields = window.nestedFormEvents.insertFields

  window.nestedFormEvents.insertFields = (content, association, link) ->
    target = $(link).data('target')
    isScreenshotEditor = association == 'screenshots' && $(link).data('screenshot-add')

    if isScreenshotEditor && target
      $(content).appendTo($(target))
    else
      originalInsertFields.call(window.nestedFormEvents, content, association, link)

refreshScreenshotEditor = (editor) ->
  editor = $(editor)
  cards = editor.find('> [data-screenshot-items] > .fields')
  activeCards = cards.not('.is-removed')
  editor.find('> [data-screenshot-empty]').toggle(activeCards.length == 0)

prepareScreenshotCard = (field) ->
  field = $(field)
  field.removeClass('tab-pane').addClass('ie-screenshot-editor__item').show()

  destroyInput = field.find('[data-screenshot-destroy]')
  field.toggleClass('is-removed', destroyInput.val() == '1')
  refreshScreenshotEditor(field.closest('[data-screenshot-editor]'))

initializeScreenshotEditors = (scope) ->
  scope = $(scope || document)
  editors = scope.find('[data-screenshot-editor]')
  editors = editors.add(scope.filter('[data-screenshot-editor]'))

  editors.each ->
    editor = $(this)
    editor.find('> [data-screenshot-items] > .fields').each ->
      prepareScreenshotCard(this)
    refreshScreenshotEditor(editor)

$(document).on 'nested:fieldAdded:screenshots', 'form', (event) ->
  field = $(event.field)
  return unless field.closest('[data-screenshot-editor]').length

  prepareScreenshotCard(field)

$(document).on 'change', '[data-screenshot-file]', ->
  input = this
  file = input.files && input.files[0]
  return unless file

  card = $(input).closest('.fields')
  image = card.find('[data-screenshot-image]')
  reader = new FileReader()

  reader.onload = (event) ->
    image.attr('src', event.target.result).show()
    card.find('[data-screenshot-placeholder]').hide()

  reader.readAsDataURL(file)
  card.find('[data-screenshot-filename]').text(file.name).attr('title', file.name)
  card.find('[data-screenshot-status]').text('Ready to upload when you save')
  card.find('[data-screenshot-upload-label]').text('Change image')

$(document).on 'click', '[data-screenshot-remove]', ->
  field = $(this).closest('.fields')
  field.find('[data-screenshot-destroy]').val('1')
  field.addClass('is-removed')
  refreshScreenshotEditor(field.closest('[data-screenshot-editor]'))

$(document).on 'click', '[data-screenshot-undo]', ->
  field = $(this).closest('.fields')
  field.find('[data-screenshot-destroy]').val('0')
  field.removeClass('is-removed')
  refreshScreenshotEditor(field.closest('[data-screenshot-editor]'))

$(document).ready ->
  installScreenshotInsertFields()
  initializeScreenshotEditors(document)

$(document).on 'rails_admin.dom_ready', (event, content) ->
  initializeScreenshotEditors(content || document)
