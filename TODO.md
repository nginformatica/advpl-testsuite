# TODO

- [ ] Add verbose mode to TestSuite
    - [ ] Add a way to enable verbose flag
    - [ ] When verbose flag is on, log each expectation
- [ ] Expectations
    - [x] `ToBe`
    - [x] `ToThrowError`
    - [x] `ToHaveType`
- [ ] Implement deep look on `ToBe`
    - [ ] Different types should make the test fail
    - [ ] Object lookup is by name and properties
    - [ ] Array lookup is by length and elements
