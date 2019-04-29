"
I represent a class that does not exist. This can be the case when a class superclass is not available. Instead of breaking and having different behavior (putting Object, nil) now Pharo creates an UndefinedClass object. It is the pendant of Undeclared (for references to unknow classes).

 There is more details on the UndefineClass article written by S. Ducasse, G. Polito and L. Fabresse at IWST 2017 and available at https://hal.inria.fr/hal-01585305v1. 




Test Cases to be covered in the future

 - Have an undefined class with methods and change the superclass
 - Have an undefined class and instantiate it
 - Have an undefined class with a subclass and instantiate a subclass
 - Have an undefined class 
"
Class {
	#name : #UndefinedClass,
	#superclass : #Object,
	#category : #'UndefinedClasses-Core'
}

{ #category : #'instance creation' }
UndefinedClass class >> basicNew [
	"Normally redefine basicNew is a bad idea. But here we must do it."
	UndefinedClassError signal: 'Cannot instantiate undefined class: ', self name
]

{ #category : #building }
UndefinedClass class >> createUndefinedClassNamed: aString package: aPackageName [
	
	^ self
		subclass: aString
		instanceVariableNames: ''
		classVariableNames: ''
		package: aPackageName
]

{ #category : #'reflective operations' }
UndefinedClass >> doesNotUnderstand: aMessage [
	
	UndefinedClassError signal
]