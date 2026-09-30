# False-green wrapper

## Failure

A historical wrapper could encounter a setup failure before the intended inner
tests ran and still return success. The outer zero exit status was then treated
as evidence that the intended checks had passed.

This is a minimized reproduction of that failure class, not the original
wrapper.

## Why the specimen is bad

It conflates:

- wrapper exit status;
- pipeline exit status;
- whether the required inner task started;
- whether all expected task records exist; and
- whether the intended source revision was tested.

It also prints `PASS` regardless of the evidence.

## Regression

The fixture should make setup or the inner command fail while a naive wrapper
still reaches the end. Kitchen must reject the result unless the intended source
revision and every required task result are present and successful.

Related: Kitchen issue #10.
