# Data Normalizer Challenge

For the chanllenge I've created a library called [Normalizator](https://github.com/omarandstuff/normalizator), a general solution for data normalization.

Original gist: https://gist.github.com/JonaMX/4ba3f333fbe1f1346cb7191e01b93a45

### Project structure
```
- examples
  |- tango_source.md // You are here
  |- tango_source.rb // ****** This is the file you are looking for *****
- lib
  |- normalizator
    |- normalize.rb // this file contains the main logic
  |- rules
    |- base_rule.rb // Intended to be used for any rule, used for numeric and enum ones
    |- enum_rule.rb // Cheks if field falls in a set of enumerators
    |- numeric_rule.rb // Cheks if field contains a number and set it as a number object
  |- normalizator.rb // Main module and module function declaration
- spec // Spec tets
```

### Run the challenge

You need to install `normalizator` in your system

```shell
  gem install normalizator
```

#### Just getting the example file

```shell
curl https://raw.githubusercontent.com/omarandstuff/normalizator/master/examples/tango_source.rb > tango_source.rb
ruby tango_source.rb

# Case 1: succes!
# Case 2: succes!
# Case 3: succes!
# Case 4: succes!
```

#### Clonning the repo

```shell
git clone https://github.com/omarandstuff/normalizator
cd normalizator

ruby examples/tango_source.rb

# Case 1: succes!
# Case 2: succes!
# Case 3: succes!
# Case 4: succes!
```

Happy reviewing!