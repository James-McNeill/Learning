# non-public methods

'''
Create non-public methods within the class which can be used when the user instansiates the class instance. 
The _ before the method highlights that the method is non-public. In turn this means that the user of the 
class doesn't have to worry about performing this step.
'''
class Document:
  def __init__(self, text):
    self.text = text
    # Tokenize the document with non-public tokenize method
    self.tokens = self._tokenize()
    # Perform word count with non-public count_words method
    self.word_counts = self._count_words()

  def _tokenize(self):
    return tokenize(self.text)
	
  # non-public method to tally document's word counts with Counter
  def _count_words(self):
    return Counter(self.tokens)
