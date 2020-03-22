describe('Popup', function() {
    it('closes on clicking Close button', function() {
        cy.visit('/') 
        cy.contains('Start game').click()
        cy.get('.popup').contains('Close').click()
    })
  })