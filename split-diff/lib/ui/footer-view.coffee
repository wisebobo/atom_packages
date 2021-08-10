module.exports =
class FooterView
  constructor: (isWhitespaceIgnored, disableIgnoreWhitespace, isAutoDiffEnabled, disableAutoDiff) ->
    # create root UI element
    @element = document.createElement('div')
    @element.classList.add('split-diff-ui')

    # ------------
    # LEFT COLUMN |
    # ------------

    # create prev diff button
    prevDiffButton = document.createElement('button')
    prevDiffButton.classList.add('btn')
    prevDiffButton.classList.add('btn-md')
    prevDiffButton.classList.add('prev-diff')
    prevDiffButton.onclick = () ->
      atom.commands.dispatch(atom.views.getView(atom.workspace), 'split-diff:prev-diff')
    prevDiffButton.title = 'Move to Previous Diff'
    # create next diff button
    nextDiffButton = document.createElement('button')
    nextDiffButton.classList.add('btn')
    nextDiffButton.classList.add('btn-md')
    nextDiffButton.classList.add('next-diff')
    nextDiffButton.onclick = () ->
      atom.commands.dispatch(atom.views.getView(atom.workspace), 'split-diff:next-diff')
    nextDiffButton.title = 'Move to Next Diff'

    # create selection counter
    @selectionCountValue = document.createElement('span')
    @selectionCountValue.classList.add('selection-count-value')
    @element.appendChild(@selectionCountValue)
    # create selection divider
    selectionDivider = document.createElement('span')
    selectionDivider.textContent = '/'
    selectionDivider.classList.add('selection-divider')
    @element.appendChild(selectionDivider)
    # create selection count container
    @selectionCount = document.createElement('div')
    @selectionCount.classList.add('selection-count')
    @selectionCount.classList.add('hidden')
    # add items to container
    @selectionCount.appendChild(@selectionCountValue)
    @selectionCount.appendChild(selectionDivider)

    # create number of differences value
    @numDifferencesValue = document.createElement('span')
    @numDifferencesValue.classList.add('num-diff-value')
    @numDifferencesValue.classList.add('split-diff-loading-icon')
    # create number of differences text
    @numDifferencesText = document.createElement('span')
    @numDifferencesText.textContent = 'differences'
    @numDifferencesText.classList.add('num-diff-text')
    # create number of differences container
    numDifferences = document.createElement('div')
    numDifferences.classList.add('num-diff')
    # add items to container
    numDifferences.appendChild(@numDifferencesValue)
    numDifferences.appendChild(@numDifferencesText)
    # create left column and add prev/next buttons and number of differences text
    left = document.createElement('div')
    left.classList.add('left')
    left.appendChild(prevDiffButton)
    left.appendChild(nextDiffButton)
    left.appendChild(@selectionCount)
    left.appendChild(numDifferences)
    # add container to UI
    @element.appendChild(left)

    # -----------
    # MID COLUMN |
    # -----------

    # create copy to left button
    copyToLeftButton = document.createElement('button')
    copyToLeftButton.classList.add('btn')
    copyToLeftButton.classList.add('btn-md')
    copyToLeftButton.classList.add('copy-to-left')
    copyToLeftButton.onclick = () ->
      atom.commands.dispatch(atom.views.getView(atom.workspace), 'split-diff:copy-to-left')
    copyToLeftButton.title = 'Copy to Left'
    #copyToLeftButton.textContent = 'Copy to Left'
    # create copy to right button
    copyToRightButton = document.createElement('button')
    copyToRightButton.classList.add('btn')
    copyToRightButton.classList.add('btn-md')
    copyToRightButton.classList.add('copy-to-right')
    copyToRightButton.onclick = () ->
      atom.commands.dispatch(atom.views.getView(atom.workspace), 'split-diff:copy-to-right')
    copyToRightButton.title = 'Copy to Right'
    #copyToRightButton.textContent = 'Copy to Right'
    # create mid column
    mid = document.createElement('div')
    #mid.classList.add('btn-group')
    mid.classList.add('mid')
    # add buttons to button group
    mid.appendChild(copyToLeftButton)
    mid.appendChild(copyToRightButton)
    @element.appendChild(mid)

    # -------------
    # RIGHT COLUMN |
    # -------------

    # create ignore whitespace checkbox
    @ignoreWhitespaceValue = document.createElement('input')
    @ignoreWhitespaceValue.type = 'checkbox'
    @ignoreWhitespaceValue.id = 'ignore-whitespace-checkbox'
    # set checkbox value to current package ignore whitespace setting
    @ignoreWhitespaceValue.checked = isWhitespaceIgnored
    # set checkbox to disabled if service is overriding
    @ignoreWhitespaceValue.disabled = disableIgnoreWhitespace
    # register command to checkbox
    @ignoreWhitespaceValue.addEventListener('change', () ->
      atom.commands.dispatch(atom.views.getView(atom.workspace), 'split-diff:set-ignore-whitespace')
    )
    # create ignore whitespace label
    ignoreWhitespaceLabel = document.createElement('label')
    ignoreWhitespaceLabel.classList.add('ignore-whitespace-label')
    ignoreWhitespaceLabel.htmlFor = 'ignore-whitespace-checkbox'
    ignoreWhitespaceLabel.textContent = 'Ignore Whitespace'

    # create ignore whitespace checkbox
    @autoDiffValue = document.createElement('input')
    @autoDiffValue.type = 'checkbox'
    @autoDiffValue.id = 'auto-diff-checkbox'
    # set checkbox value to current package ignore whitespace setting
    @autoDiffValue.checked = isAutoDiffEnabled
    # set checkbox to disabled if service is overriding
    @autoDiffValue.disabled = disableAutoDiff
    # register command to checkbox
    @autoDiffValue.addEventListener('change', () ->
      atom.commands.dispatch(atom.views.getView(atom.workspace), 'split-diff:set-auto-diff')
    )
    # create ignore whitespace label
    autoDiffLabel = document.createElement('label')
    autoDiffLabel.classList.add('auto-diff-label')
    autoDiffLabel.htmlFor = 'auto-diff-checkbox'
    autoDiffLabel.textContent = 'Auto Diff'

    # create right column
    right = document.createElement('div')
    right.classList.add('right')
    # add items to container
    right.appendChild(@ignoreWhitespaceValue)
    right.appendChild(ignoreWhitespaceLabel)
    right.appendChild(@autoDiffValue)
    right.appendChild(autoDiffLabel)
    # add settings to UI
    @element.appendChild(right)

  # Tear down any state and detach
  destroy: ->
    @element.remove()
    @footerPanel.destroy()

  getElement: ->
    @element

  createPanel: ->
    @footerPanel = atom.workspace.addBottomPanel(item: @element)

  show: ->
    @footerPanel.show()

  hide: ->
    @footerPanel.hide()

  setLoading: ->
    @numDifferencesValue.textContent = null
    @numDifferencesValue.classList.add('split-diff-loading-icon')

  # set the number of differences value
  setNumDifferences: (num) ->
    @numDifferencesValue.classList.remove('split-diff-loading-icon')
    if num == 1
      @numDifferencesText.textContent = 'difference'
    else
      @numDifferencesText.textContent = 'differences'
    @numDifferencesValue.textContent = num

  # show the selection counter next to the number of differences
  # it will turn 'Y differences' into 'X / Y differences'
  showSelectionCount: (count) ->
    @selectionCountValue.textContent = count
    @selectionCount.classList.remove('hidden')

  # hide the selection counter next to the number of differences
  hideSelectionCount: () ->
    @selectionCount.classList.add('hidden')

  # set the state of the ignore whitespace checkbox
  setIgnoreWhitespace: (isWhitespaceIgnored) ->
    @ignoreWhitespaceValue.checked = isWhitespaceIgnored

  # set the state of the auto diff checkbox
  setAutoDiff: (isAutoDiffEnabled) ->
    @autoDiffValue.checked = isAutoDiffEnabled
