Foxie = require 'foxie'
array = require 'utila/scripts/js/lib/array'
PropViewRepo = require './timelineView/PropViewRepo'

module.exports = class TimelineView

	constructor: (@mainBox) ->

		@model = @mainBox.editor.model.timeline

		@_repo = new PropViewRepo @

		@_currentProps = []

		do @_prepareNode

		do @_prepareListeners

	_prepareListeners: ->

		@mainBox.on 'width-change', => do @_relayout

		@model.on 'focus-change', => do @_relayout

		@model.on 'prop-add', (propHolder) => @_add propHolder

		@model.on 'prop-remove', (propHolder) => @_remove propHolder

	_prepareNode: ->

		@node = Foxie('.timeflow-timeline').putIn(@mainBox.node)

	_add: (propHolder) ->

		propView = @_repo.getPropViewFor propHolder

		@_currentProps.push propView

		do propView.attach

		return

	_remove: (propHolder) ->

		for propView in @_currentProps

			if propView.id is propHolder.id

				propViewToRemove = propView

		unless propViewToRemove?

			throw Error "Couldn't find prop '#{propHolder.id}' in the current props list"

		array.pluckOneItem @_currentProps, propViewToRemove

		do propViewToRemove.detach

		return