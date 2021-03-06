"
My subclasses know how to render a Hiedra visualization (HiRuler) using Athens.

"
Class {
	#name : #HiAbstractRenderer,
	#superclass : #Object,
	#instVars : [
		'ruler',
		'rowsInterval'
	],
	#category : #'Hiedra-UI'
}

{ #category : #accessing }
HiAbstractRenderer >> cellWidth [
	^ self subclassResponsibility
]

{ #category : #API }
HiAbstractRenderer >> formHeight [
	"Answer the height in pixels for the form to be rendered."

	^ rowsInterval size * self rowHeight
]

{ #category : #API }
HiAbstractRenderer >> formWidth [
	"Answer the width in pixels for the form to be rendered."

	"Note: The reason of numberOfColumns + 2 is the left and right margin."
	^ (ruler numberOfColumns + 2) * self cellWidth
]

{ #category : #rendering }
HiAbstractRenderer >> initialTranslationInAthensCanvas [
	"Apply left margin + rowsInterval offset."

	^ self cellWidth @ (-1 * (rowsInterval first - 1) * self rowHeight)
]

{ #category : #API }
HiAbstractRenderer >> newForm [
	"Answer a new form, rendered with the current ruler and rowInterval."
	
	| athensSurface |
	athensSurface := AthensCairoSurface extent: self formWidth @ self formHeight.
	
	athensSurface drawDuring: [ :athensCanvas |
		athensCanvas pathTransform translateBy: self initialTranslationInAthensCanvas.

		self renderOn: athensCanvas ].

	^ athensSurface asForm
]

{ #category : #rendering }
HiAbstractRenderer >> renderLinks: links on: athensCanvas [ 

	self subclassResponsibility
]

{ #category : #rendering }
HiAbstractRenderer >> renderNodes: nodes on: athensCanvas [

	self subclassResponsibility
]

{ #category : #rendering }
HiAbstractRenderer >> renderOn: athensCanvas [
	"Render all nodes and links that correspond to the previously selected rowsInterval in the athensCanvas."
	
	| links nodes |
	nodes := rowsInterval collect: [:row | ruler nodeAtRow: row ].
	links := rowsInterval flatCollect: [:row | ruler linksAtRow: row ] as: Set.

	self renderLinks: links on: athensCanvas.
	self renderNodes: nodes on: athensCanvas.
]

{ #category : #accessing }
HiAbstractRenderer >> rowHeight [
	^ self subclassResponsibility
]

{ #category : #accessing }
HiAbstractRenderer >> rowsInterval [
	^ rowsInterval
]

{ #category : #accessing }
HiAbstractRenderer >> rowsInterval: anObject [
	rowsInterval := anObject
]

{ #category : #accessing }
HiAbstractRenderer >> ruler [
	^ ruler
]

{ #category : #accessing }
HiAbstractRenderer >> ruler: anObject [
	ruler := anObject
]
