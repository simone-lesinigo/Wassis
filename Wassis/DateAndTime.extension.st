Extension { #name : 'DateAndTime' }

{ #category : '*Wassis' }
DateAndTime class >> nowAsString [
	"Return time now formatted as dd-mm-yy_hh-mm-ss"

	| now timeAsString |
   now := self now.
   timeAsString := String streamContents: [ :s |
   		now dayOfMonth printOn: s base: 10 length: 2 padded: true.
      s nextPut: $-.
      now monthIndex printOn: s base: 10 length: 2 padded: true.
      s nextPut: $-.
      now year printOn: s.     
      s nextPutAll: '_'.
      now hour printOn: s base: 10 length: 2 padded: true.
      s nextPut: $h. 
      now minute printOn: s base: 10 length: 2 padded: true.
		s nextPut: $m. 
		now seconds printOn: s base: 10 length: 2 padded: true.
		s nextPut: $s. 
    ].
	
	^ timeAsString
]
