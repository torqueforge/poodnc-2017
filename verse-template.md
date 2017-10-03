# Verse template refactoring

Starting point:
- BottleNumber.for factory in place
- Successor fixed

Introduce new requirement. We want to be able to produce other kinds of songs
with descending verses. We want to vary the verses. Make an object that plays a
role, then can make other objects that play that role, extract and inject.

Discuss testing approach. We already have tests that verify verse output. Make a
new class `BottleVerse`, with `attr_reader` and `initialize`, copy the `verse`
method. Write the code to forward to the new method from existing
`Bottles#verse` method. We don't like the way that looks `BottleVerse.verse`. A
better name is `lyrics`. Write the code I wish I had. Go into the new class and
change `verse` method name to `lyrics`. Uncomment the forwarding code for
`lyrics` and  run tests. Tests should pass. We've now extracted the class but we
haven't yet injected it.

We look at the `Bottles` class and discover there's no longer anything in there
about bottles.

Now we need to inject the dependency. Rely on abstraction not concrete class
name. Add an `attr_reader :verse_factory` and a named argument to `initialize`:
`verse_factory: BottleVerse`. Use the injected class name in the forwarding line
of code in `Bottles#verse`.

Then we go look at the tests and discover that they no longer tell us what we
expect. The tests should tell you what it does (discussion about what the
expectaton is). Let's make some tests for `BottleVerse` whose job is indeed to
produce the lyrics for the bottle verse. Copy the existing bottle verse tests
into a new tests for `BottleVerse`. Make necessary changes, delete old tests,
get back to original number of tests.

Let's look at the rest of the tests. That name `Bottles` is bothering us. We've
come up with `DescendingVerseSong` but we hope someone in class will come up
with something we like more. The name seems bad but it's accurate and not
abstract. We want better tests for `DescendingVerseSong` that reveal the intent
of counting down. We don't have to stub. We can make a new thing that plays the
role that of course conforms to the API that we have. Make `VerseDouble`.

Make a new test method above the existing test method, but with the same name.
This will allow us to parse and execute while making changes on more than one
line. This is a really useful refactoring technique. The `test_a_few_verses`
tests is now redundant - remove it.

Now we look at the whole song test. It does 100 verses because of the magic
number. That ought to be optional too. Let's inject it so that we can vary it.
This is the key language to use.

Again use the technique of a new test with the same name as an existing test
(`test_the_whole_song`) above that one, so we can parse and execute. Inject
`highest` and `lowest` and use them in the production code. Now we can inject a
smaller range for the song test, again using the `VerseDouble`. Inject a new
`highest`, something like 4. Remove the old whole song test. Now the tests are
simpler, shorter, and more intention-revealing.

We *do* want a `test_a_verse` test in the tests for `DescendingVerseSong` since
it's part of the public API. Interesting discussion because the double
interpolates the number. (Not sure if this point is in the right order for
discussion, but it's good here for now.)

Demeter violation in the verse forwarding. Fix with
`verse_factory.lyrics(number)`. Even when we're just parsing and executing in
the production code, the tests will break because we have changed the API
expectation for objects that play the role. We have to update the API for all
objects that play that role. But now in the test double, we *are* willing to
just return the string from the class-scope `lyrics` method, removing everything
but the class method. It's now simpler.

Once the API of `BottleVerse` becomes just `lyrics(number)`, change the `BottleVerseTest` to make assertions about `BottleVerse.lyrics(number)` rather than `BottleVerse.new(number).lyrics`.

We can accept the default of `BottleVerse` for now. It's fine. The fact that
the class name of `BottleNumber` is known to and hardcoded in `BottleVerse` is
fine. These two things are not going to vary independently.

Question: why not `BottleVerse.new.lyrics(number)`? Is this a mutation/caching
concern. Yes. More like value object. Prefer immutability. It's okay to make new
objects.
