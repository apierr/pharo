"
SpecInterpreter
	interpretASpec: MorphicButtonAdapter  defaultSpec
	model: (MorphicButtonAdapter model: ButtonPresenter new)

"
Class {
	#name : #SpMorphicButtonAdapter,
	#superclass : #SpAbstractMorphicAdapter,
	#instVars : [
		'subMenuWidget'
	],
	#category : #'Spec2-Adapters-Morphic-Base'
}

{ #category : #'widget API' }
SpMorphicButtonAdapter >> action [

	self showSubMenuIfPresent.

	self widget ifNotNil: [:m | m takeKeyboardFocus ].
	self model performAction.
]

{ #category : #protocol }
SpMorphicButtonAdapter >> askBeforeChanging [

	^ self model askBeforeChanging
]

{ #category : #private }
SpMorphicButtonAdapter >> buildLabel: text withIcon: icon [

	icon ifNil: [ ^ text
			ifNil: [ '' ]
			ifNotNil: [ text ] ].
	
	^ IconicListItem 
		text: text 
		icon: icon

]

{ #category : #factory }
SpMorphicButtonAdapter >> buildWidget [
	| button | 

	button := PluggableButtonMorph
				on: self 
				getState: #state 
				action:  #action 
				label: #label 
				menu: #menu:.

	button 
		getEnabledSelector: #enabled ;
		getFontSelector: #font ;
		hResizing: #spaceFill ;
		vResizing: #spaceFill ;
		askBeforeChanging: self askBeforeChanging ;
		setBalloonText: self model help ;
		dragEnabled: self dragEnabled;
		dropEnabled: self dropEnabled ;	
		eventHandler: (MorphicEventHandler new on: #keyStroke send: #keyStroke:fromMorph: to: self).
	
	self color ifNotNil: [ self setWidgetColor: button ].
	
	button bindKeyCombination: Character space toAction: [ self action ].

	^ button
]

{ #category : #emulating }
SpMorphicButtonAdapter >> clicked [	

	| evt |
	evt := MouseButtonEvent new setType: nil position: widget center which: MouseButtonEvent redButton buttons: MouseButtonEvent redButton hand: nil stamp: nil.

	(widget handlesMouseDown: evt) ifTrue: [
		widget mouseDown: evt.
		widget mouseUp: evt].

]

{ #category : #'menus support' }
SpMorphicButtonAdapter >> deleteIfPopUp: evt [
]

{ #category : #'widget API' }
SpMorphicButtonAdapter >> font [
	^self model font
]

{ #category : #accessing }
SpMorphicButtonAdapter >> helpText [
	^ self widget helpText
]

{ #category : #accessing }
SpMorphicButtonAdapter >> icon [
	^ widget label icon
]

{ #category : #'menus support' }
SpMorphicButtonAdapter >> isSelected: aBooolean [
]

{ #category : #'widget API' }
SpMorphicButtonAdapter >> keyStroke: anEvent fromMorph: aMorph [
]

{ #category : #'widget API' }
SpMorphicButtonAdapter >> label [
	
	^ self buildLabel: self model label withIcon: self model icon
]

{ #category : #'widget API' }
SpMorphicButtonAdapter >> menu: aMenu [
	| menuPresenter |

	menuPresenter := self model contextMenu.
	menuPresenter ifNil: [ ^ nil ].
	^ SpBindings
		value: self model application adapterBindings
		during: [ menuPresenter buildWithSpec ]
]

{ #category : #factory }
SpMorphicButtonAdapter >> setWidgetColor: button [

		| normalColorBlock clickedColorBlock |

		normalColorBlock := [ :aButton |
							(aButton valueOfProperty: #noFill ifAbsent: [false]) 
								ifTrue: [ SolidFillStyle color: Color transparent ]
								ifFalse: [ SolidFillStyle color: self color ] ].
	
		clickedColorBlock := [ :aButton | SolidFillStyle color: self color muchDarker ].
		button theme: ((SpUIThemeDecorator theme: button theme)
							property: #buttonNormalFillStyleFor: returnsValueOf: normalColorBlock;
							property: #buttonMouseOverFillStyleFor: returnsValueOf: normalColorBlock;
							property: #buttonPressedFillStyleFor: returnsValueOf: clickedColorBlock;
							yourself).

]

{ #category : #'widget API' }
SpMorphicButtonAdapter >> showSubMenuIfPresent [
	self model contextMenu
		ifNotNil: [ self model menu menuGroups isEmpty
				ifFalse: [ subMenuWidget
						ifNotNil: [ subMenuWidget delete.
							subMenuWidget := nil ].
					subMenuWidget := (SpMorphicMenuAdapter
						adaptAsPopup: self model menu) widget.
					subMenuWidget
						popUpAdjacentTo:
							{self widget bounds bottomLeft.
							self widget bounds bottomRight}
						forHand: ActiveHand
						from: self widget.
					subMenuWidget popUpOwner: self ] ]
]

{ #category : #'widget API' }
SpMorphicButtonAdapter >> state [

	^ self model state
]

{ #category : #accessing }
SpMorphicButtonAdapter >> unscaledInitialExtent [

	^ 15@26
]

{ #category : #updating }
SpMorphicButtonAdapter >> updateMenu [
	
	"there is no need to updateMenu here because it will be resolved at #menu:"
]
