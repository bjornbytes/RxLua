local Observable = require 'observable'

Observable.wrap = Observable.buffer
Observable['repeat'] = Observable.replicate
