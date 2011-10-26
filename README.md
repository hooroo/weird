WeIRD
=============

A library for validating New Zealand IRD (tax) numbers.

Usage
-----

		Weird.valid_ird?(ird_string)

Returns true if the ird is a valid ird as per the validation rules specified by the NZ Internal Revenue.
See their spec for details: http://www.ird.govt.nz/resources/c/5/c5a1198040c469449d4bbddaafba9fa8/payroll-spec-2011-v3.pdf

Testing
-------

To run the tests:

    $ rake

To add tests see the `Commands` section earlier in this
README.


