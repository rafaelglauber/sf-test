@isTest
public class ViaCepAddressClientTest {
    
    private class MockHttpResponse implements HttpCalloutMock {
        private String response;
        private Integer statusCode;
        
        public MockHttpResponse(String response, Integer statusCode) {
            this.response = response;
            this.statusCode = statusCode;
        }
        
        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse res = new HTTPResponse();
            res.setBody(this.response);
            res.setStatusCode(this.statusCode);
            return res;
        }
    }
    
    @isTest
    static void testGetAddress() {
        // Simula a resposta da API do Via CEP para um CEP válido
        String cepValido = '01310-100';
        String responseValido = '{"cep":"01310-100","logradouro":"Avenida Paulista","complemento":"até 610 - lado par","bairro":"Bela Vista","localidade":"São Paulo","uf":"SP","ibge":"3550308","gia":"1004","ddd":"11","siafi":"7107"}';
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse(responseValido, 200));
        
        AddressClient.AddressResponse addressValido = ViaCepAddressClient.create().getAddress(cepValido);
        System.assertEquals('Avenida Paulista', addressValido.logradouro);
        System.assertEquals('Bela Vista', addressValido.bairro);
        System.assertEquals('São Paulo', addressValido.localidade);
        System.assertEquals('SP', addressValido.uf);
        
        // Simula a resposta da API do Via CEP para um CEP inválido
        String cepInvalido = '12345-678';
        String responseInvalido = '{"erro": true}';
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse(responseInvalido, 404));
        
        AddressClient.AddressResponse addressInvalido = ViaCepAddressClient.create().getAddress(cepInvalido);
        System.assertEquals(null, addressInvalido);
    }
}
