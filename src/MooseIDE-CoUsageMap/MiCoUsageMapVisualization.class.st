"
I use the MiCoUsageMapMooseBuilder like a bridge for the for the browser
"
Class {
	#name : #MiCoUsageMapVisualization,
	#superclass : #MiAbstractVisualization,
	#instVars : [
		'coUsageMap'
	],
	#category : #'MooseIDE-CoUsageMap-Browser'
}

{ #category : #brokerage }
MiCoUsageMapVisualization >> consume: anItem [
	anItem class = FamixTag
		ifTrue: [ self consumeTag: anItem ]
		ifFalse: [ self consumeTagAssociation: anItem ]
]

{ #category : #brokerage }
MiCoUsageMapVisualization >> consumeTag: aTag [
	self updateLegend
]

{ #category : #brokerage }
MiCoUsageMapVisualization >> consumeTagAssociation: aFamixTagAssociation [
	| entity tag miCoObject |
	entity := aFamixTagAssociation entity.
	tag := aFamixTagAssociation tag.
	miCoObject := coUsageMap miMethods , coUsageMap miAttributes 
		detect: [ :each | each rawObject = entity and: [ each tag ~= tag ] ] ifNone: [ nil ].
	miCoObject ifNil: [ ^ self ].
	miCoObject tag: tag.
	coUsageMap updateShapeColors
]

{ #category : #highlighting }
MiCoUsageMapVisualization >> highlightShapes [
	^ #()
]

{ #category : #initialization }
MiCoUsageMapVisualization >> initialize [
	super initialize.
	self script: [ :canvas | canvas ].
	coUsageMap := MiCoUsageMapMooseBuilder new.
	coUsageMap visualization: self.
]

{ #category : #brokerage }
MiCoUsageMapVisualization >> itemsFor: aClass [
	| model |
	model := self owner collectionModel mooseModel.
	
	aClass = FamixTagAssociation ifTrue: [ ^ model allTagAssociations ].
	aClass = FamixTag ifTrue: [ ^ model allTags ].
	^ #(  )
]

{ #category : #actions }
MiCoUsageMapVisualization >> openSettingsBrowser [
	^ coUsageMap markManager openSettingsBrowser
]

{ #category : #brokerage }
MiCoUsageMapVisualization >> remove: anObject [
	anObject class = FamixTag
		ifTrue: [ self removeTag: anObject ]
		ifFalse: [ self removeTagAssociation: anObject ].
	
]

{ #category : #brokerage }
MiCoUsageMapVisualization >> removeTag: aTag [
	| canvas legendTag |
	canvas := coUsageMap canvas.
	legendTag := coUsageMap legendTag.
	
	"updating legend"
	self tagsFromMooseModel: self owner collectionModel mooseModel.
	legendTag build.
	
	coUsageMap markManager removeTag: aTag.
	canvas signalUpdate.
]

{ #category : #brokerage }
MiCoUsageMapVisualization >> removeTagAssociation: aFamixTagAssociation [
	| entity miCoObject |
	entity := aFamixTagAssociation entity.
	miCoObject := coUsageMap miMethods , coUsageMap miAttributes 
		detect: [ :each | each rawObject = entity ] ifNone: [ nil ].
	miCoObject ifNil: [ ^ self ].
	"this avoids call the consumer producer system"
	miCoObject privateTag: nil.
	coUsageMap updateShapeColors
]

{ #category : #running }
MiCoUsageMapVisualization >> run [
	| model |
	super run.
	model := self owner collectionModel.
	coUsageMap 
		container: self canvas;
		methods: model;
		application: self owner application.
	self updateLegend.
	coUsageMap build.
]

{ #category : #brokerage }
MiCoUsageMapVisualization >> tagsFromMooseModel: aMooseModel [
	| group legendTag |
	aMooseModel ifNil: [ ^ self ]. 
	legendTag := coUsageMap legendTag.
	legendTag removeOldLegend.
	group := aMooseModel allTags sorted: [ :a :b | a name < b name ].
	group do: [ :tag | legendTag addTag: tag asMiCoTag ].
]

{ #category : #brokerage }
MiCoUsageMapVisualization >> update: anObject [
	self consume: anObject
]

{ #category : #brokerage }
MiCoUsageMapVisualization >> updateLegend [
	| legendTag |
	legendTag := coUsageMap legendTag.
	self tagsFromMooseModel: self owner collectionModel mooseModel.
	legendTag build.
	coUsageMap updateShapeColors.
]
