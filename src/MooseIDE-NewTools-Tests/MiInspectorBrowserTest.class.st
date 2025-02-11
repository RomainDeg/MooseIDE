"
A MiInspectorBrowserTest is a test class for testing the behavior of MiInspectorBrowser
"
Class {
	#name : #MiInspectorBrowserTest,
	#superclass : #MiAbstractBrowserTest,
	#category : #'MooseIDE-NewTools-Tests'
}

{ #category : #'tests - actions' }
MiInspectorBrowserTest >> assertFollowActionFor: aMooseObject [

	self assert: browser miInspector model equals: aMooseObject
	
]

{ #category : #running }
MiInspectorBrowserTest >> browserClass [

	^ MiInspectorBrowser
]

{ #category : #tests }
MiInspectorBrowserTest >> testCanPropagateMooseEntity [

	browser followEntity: MooseEntity new.

	self assert: browser canPropagate.
	self assert: (browser toolbarButton: 'Propagate') isEnabled

]

{ #category : #tests }
MiInspectorBrowserTest >> testCanPropagateMooseGroup [

	browser followEntity: self mooseObjects asMooseGroup.

	self assert: browser canPropagate.
	self assert: (browser toolbarButton: 'Propagate') isEnabled

]

{ #category : #tests }
MiInspectorBrowserTest >> testCannotPropagatePharoCollection [

	browser followEntity: self mooseObjects.

	self deny: browser canPropagate.
	self deny: (browser toolbarButton: 'Propagate') isEnabled

]
