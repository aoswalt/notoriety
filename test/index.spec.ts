import { hello } from '../src'

describe('the api', () => {
  test('says hello', () => {
    expect(hello()).toMatch(/world/)
    expect(hello('user')).toMatch(/user/)
  })
})
