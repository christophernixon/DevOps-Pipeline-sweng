describe('Start button', function() {
    it('renders', function() {
        cy.visit('/') 
        cy.contains('Start game')
    })
    it('opens popup', function() {
        cy.visit('/') 
        cy.contains('Start game').click()
        cy.get('.popup')
    })
  })