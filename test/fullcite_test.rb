require 'minitest/autorun'
require 'test/unit'
include Test::Unit::Assertions

require 'asciidoctor-bibtex'

describe AsciidoctorBibtex do

  def check_complete_citation style, line, result, links = false
    cs = AsciidoctorBibtex::Citations.new
    p = AsciidoctorBibtex::Processor.new BibTeX.open('test/data/test.bib'), links, style
    cs.add_from_line line
    p.complete_citation(p.citations.retrieve_citations(line).first).must_equal result
  end

  it "must handle chicago style references with 'fullcite'" do
    check_complete_citation 'chicago-author-date', 'fullcite:[jones11]',
                            'Jones, K. 2011.'
    check_complete_citation 'chicago-author-date', 'fullcite:[brown09]',
                            'Brown, J., ed. 2009. _Book Title_. OUP.'
    check_complete_citation 'chicago-author-date', 'fullcite:[smith10]',
                            'Smith, D. 2010. _Book Title_. Mahwah, NJ: Lawrence Erlbaum.'
  end

  it "must handle numeric references with 'fullcite'" do
    check_complete_citation 'ieee', 'fullcite:[jones11]',
                            'K. Jones, 2011.'
    check_complete_citation 'ieee', 'fullcite:[brown09]',
                            'J. Brown, Ed., _Book title_. OUP, 2009.'
    check_complete_citation 'ieee', 'fullcite:[smith10]',
                            'D. Smith, _Book title_. Mahwah, NJ: Lawrence Erlbaum, 2010.'
  end

  it "must handle harvard style references with 'fullcite'" do
    check_complete_citation 'apa', 'fullcite:[jones11]',
                            'Jones, K. (2011).'
    check_complete_citation 'apa', 'fullcite:[brown09]',
                            'Brown, J. (Ed.). (2009). _Book title_. OUP.'
    check_complete_citation 'apa', 'fullcite:[smith10]',
                            'Smith, D. (2010). _Book title_. Mahwah, NJ: Lawrence Erlbaum.'
  end
end

