Feature: Collections
  As a hacker who likes to structure content
  I want to be able to create collections of similar information
  And render them

  Scenario: Unrendered collection
    Given I have an "index.html" page that contains "Collections: {{ site.methods }}"
    And I have fixture collections
    And I have a configuration file with "collections" set to "['methods']"
    When I run jekyll build
    Then the _site directory should exist
    And I should see "Collections: <p>Use <code>Jekyll.configuration</code> to build a full configuration for use w/Jekyll.</p>\n\n<p>Whatever: foo.bar</p>\n<p><code>Jekyll.sanitized_path</code> is used to make sure your path is in your source.</p>\n<p>Run your generators! default</p>\n<p>Create dat site.</p>\n<p>Run your generators! default</p>" in "_site/index.html"
    And the "_site/methods/configuration.html" file should not exist

  Scenario: Rendered collection
    Given I have an "index.html" page that contains "Collections: {{ site.collections }}"
    And I have an "collection_metadata.html" page that contains "Methods metadata: {{ site.collections.methods.foo }} {{ site.collections.methods }}"
    And I have fixture collections
    And I have a "_config.yml" file with content:
    """
    collections:
      methods:
        output: true
        foo:   bar
    """
    When I run jekyll build
    Then the _site directory should exist
    And I should see "Collections: {\"methods" in "_site/index.html"
    And I should see "Methods metadata: bar" in "_site/collection_metadata.html"
    And I should see "<p>Whatever: foo.bar</p>" in "_site/methods/configuration.html"

  Scenario: Rendered document in a layout
    Given I have an "index.html" page that contains "Collections: {{ site.collections }}"
    And I have a default layout that contains "<div class='title'>Tom Preston-Werner</div> {{content}}"
    And I have fixture collections
    And I have a "_config.yml" file with content:
    """
    collections:
      methods:
        output: true
        foo:   bar
    """
    When I run jekyll build
    Then the _site directory should exist
    And I should see "Collections: {\"methods" in "_site/index.html"
    And I should see "<p>Run your generators! default</p>" in "_site/methods/site/generate.html"
    And I should see "<div class='title'>Tom Preston-Werner</div>" in "_site/methods/site/generate.html"

  Scenario: Collections specified as an array
    Given I have an "index.html" page that contains "Collections: {% for method in site.methods %}{{ method.relative_path }} {% endfor %}"
    And I have fixture collections
    And I have a "_config.yml" file with content:
    """
    collections:
    - methods
    """
    When I run jekyll build
    Then the _site directory should exist
    And I should see "Collections: _methods/configuration.md _methods/sanitized_path.md _methods/site/generate.md _methods/site/initialize.md _methods/um_hi.md" in "_site/index.html"

  Scenario: Collections specified as an hash
    Given I have an "index.html" page that contains "Collections: {% for method in site.methods %}{{ method.relative_path }} {% endfor %}"
    And I have fixture collections
    And I have a "_config.yml" file with content:
    """
    collections:
      methods:
        baz: bin
    """
    When I run jekyll build
    Then the _site directory should exist
    And I should see "Collections: _methods/configuration.md _methods/sanitized_path.md _methods/site/generate.md _methods/site/initialize.md _methods/um_hi.md" in "_site/index.html"